#ifndef COMMUNICATIONBASE_MQH
#define COMMUNICATIONBASE_MQH
//+------------------------------------------------------------------+
//|                                            CommunicationBase.mqh |
//|                                              Dennis Gundersen AS |
//|                                  https://www.dennisgundersen.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Dennis Gundersen AS"
#property link      "https://www.dennisgundersen.com"

//uncomment to Print Debug information related to ZeroMQ communication
//#define DBG_ZMQ
//for debugging multiframe receive
//#define DBG_ZMQ_RCV

#include <Zmq/Zmq.mqh>

Context commContext("HourGlassZMQ");
Socket commClient(commContext, ZMQ_REQ);
const string CONNECT_MSG = "HELO";
const string CONNECT_MSG_ACK = "EHLO";
string CommLastError = "";


/**
 * @brief Internal function for reliable client receive of one frame (string)
 * 
 * @param msg 
 * @param retries 
 * @param retryInterval 
 * @return true 
 * @return false 
 */
bool CommReceiveLazyPirate(ZmqMsg &msg, int retries = 3, int retryInterval = 1000)
{
	bool received = false;
	while(retries > 0)
	{
		--retries;
		#ifdef DBG_ZMQ
		//PrintFormat("(#%d) Waiting for response", retries);
		#endif
		received = commClient.recv(msg);
		#ifdef DBG_ZMQ
		//PrintFormat("(#%d) Response available: %d", retries, received);
		#endif
		if(received)
		{
			#ifdef DBG_ZMQ
			CommReceiveLazyPirate_PrintResponse(msg, retries);
			#endif
			/*
			if(StringSubstr(msg.getData(), 0, 3) == "ERR")
			{
				CommLastError = msg.getData();
				return false;
			}
			*/
			return true;
		}
		Sleep(retryInterval);
	}
	return false;
}

bool CommReceiveCommandResponse(string &result[], int retries = 3, int retryInterval = 1000)
{
	const int RESERVED = 50;
	int cnt = 0;
	int size = ArraySize(result);
	#ifdef DBG_ZMQ_RCV
	CommResultBufferDebug(result, cnt);
	#endif
	if(size < 2)
	{
		size = ArrayResize(result, 2, RESERVED);
		if(size == -1)
		{
			CommLastError = "Receive Command: Problem with resizing result array";
			return false;
		}
	}
	ZmqMsg respFrame;
	bool more = true;
	while(more)
	{
		bool received = CommReceiveLazyPirate(respFrame, retries, retryInterval);
		if(received)
		{
			result[cnt++] = respFrame.getData();
			more = respFrame.more();
			if(more && size <= cnt)
			{
				size = ArrayResize(result, cnt+1, RESERVED);
				if(size == -1)
				{
					CommLastError = "Receive Command: Problem with resizing result array";
					return false;
				}
			}
		}
		else
		{
			CommLastError = "Frame not received - last #" + IntegerToString(cnt);
			return false;
		}
	}
	return true;
}

#ifdef DBG_ZMQ_RCV
void CommResultBufferDebug(string &b[], int step)
{
	//PrintFormat("[#%d] Result Buffer Size: %d", step, ArraySize(b));
}
#endif

void CommReceiveLazyPirate_PrintResponse(ZmqMsg& resp, int retries)
{
	//PrintFormat("(#%d) Response: more = %d, size = `%d`, data = `%s`", retries, resp.more(), resp.size(), resp.getData());
}

bool CommInitializeConnectionToServer()
{
	#ifdef DBG_ZMQ
	PrintFormat("Connecting to server… %s", server);
	#endif
	return commClient.connect(server);
}

/**
 * @brief Print received response (helper function) 
 * 
 * @param msg ZeroMQ message object
 */
void CommShowResponse(ZmqMsg& msg)
{
	//PrintFormat("Received Response: (more=%d), size=%d, message=`%s`", msg.more(), msg.size(), msg.getData());
}

/**
 * @brief Helper function for printing received response
 * 
 * @param name Name to display in BEGIN and END markers
 * @param resp Response - array of strings
 */
void CommShowResponse(string name, string& resp[])
{
	PrintFormat("//START `%s`", name);
	int size = ArraySize(resp);
	for(int i = 0; i < size; ++i)
	{
		PrintFormat("#%d/%d: `%s`", i+1, size, resp[i]);
	}
	PrintFormat("//END   `%s`", name);
}

/**
 * @brief Handshake function (optional) - could be used to early determine if server is OK
 * This could be extended to checking version - matching client and server version by changing
 * handshake messages (or including version number)
 * 
 * @return true 	Received response and it was ACK message
 * @return false 	Nothing received or response wasn't ACK message
 */
bool CommWelcome()
{
	string resp[];
	#ifdef DBG_ZMQ
	PrintFormat("Sending Connect Message… `%s`", CONNECT_MSG);
	#endif
	string payload[1];
	payload[0] = CONNECT_MSG;
	bool res = CommSendCommand(resp, payload);
	return res && resp[0] == "OK" && resp[1] == CONNECT_MSG_ACK;
}

/**
 * @brief Used for initializing client socket. Some of settings are taken from globals
 * 
 * @return true 
 * @return false 
 */
bool CommInitializeSocket()
{
   commClient.setTimeout(connectTimeout); //timeout during connection
   commClient.setReceiveTimeout(receiveTimeout); //timeout during receiving
   commClient.setSendTimeout(sendTimeout); //timeout during sending
   commClient.setReconnectInterval(reconnectInterval); //interval at which try to reconnect to server
   commClient.setReconnectIntervalMax(reconnectIntervalMax); //when total time exceeds this value stop retrying connect
   commClient.setLinger(0);
   //When Relaxed is set to true Correlated should be also enabled to avoid receiving incorrect responses
   commClient.setRequestCorrelated(true); //add id of message, response is ignored if values don't match
   commClient.setRequestRelaxed(true); //allows to send another frame even when didn't received response - should be used with above setting 
   return true;
}

//#region Functions to use - High Level

/**
 * @brief Initialize and make connection to server, with handshake
 * 
 * @param connect		Make connection to server
 * @param handshake 	When set to true, also check communication with server.
 * @return true 		Everything is ready - communication established
 * @return false 		Something was wrong
 */
bool ConnectToTradingCentral(bool connect = true, bool handshake = true)
{
	bool r = CommInitializeSocket();
	if(r)
	{
		r = CommInitializeConnectionToServer();
		if(r) 
		{
			if(handshake)
			{
				r = CommWelcome();
			}
			if(!r)
			{
				CommLastError = "Problem with handshake";
			}
		}
		else
		{
			CommLastError = "Couldn't connect to server";
		}
	}
	else
	{
		CommLastError = "Client socket initialization failed";
	}
	return r;
}

/**
 * @brief Sends command to Server
 * 
 * @param response          Received response object (reference)
 * @param data              Payload (array of strings - first is command name
 * @param retries           Response: How many times retry listening (default 3)
 * @param retryInterval     Response: Delay between retries [ms] (default 1000 = 1s)
 * @return true             When received response
 * @return false            Something was wrong
 */
bool CommSendCommand(string& response[], string &data[], int retries = 3, int retryInterval = 1000)
{
	int dataLen = ArraySize(data) - 1; //number of elements except the last one
	for(int i = 0; i < dataLen; ++i) //all except last send with more=true
	{
		#ifdef DBG_ZMQ
		//Print("Send More: " + data[i]);
		#endif
		commClient.sendMore(data[i]);
	}
	#ifdef DBG_ZMQ
	//Print("Send Last: " + data[dataLen]);
	#endif
	bool res = commClient.send(data[dataLen]); //last element send with more=false
	return CommReceiveCommandResponse(response, retries, retryInterval);
}

/**
 * @brief Sends command to Server - simplified for JSON data, it's only `command` and `JSON data`
 * 
 * @param response          Received response object (reference)
 * @param command           Command to execute 
 * @param body              Body - encoded string (for example JSON)
 * @param retries           How many times retry (default 3)
 * @param retryInterval     Delay between retries [ms] (default 1000 = 1s)
 * @return true             When received response
 * @return false            Something was wrong
 */

bool CommSendCommandSimple(string& response[], string command, string body, int retries = 3, int retryInterval = 1000)
{
	#ifdef DBG_ZMQ
	Print("Simple: Command send: " + command);
	#endif
	commClient.sendMore(command);
	#ifdef DBG_ZMQ
	Print("Simple: Body send: " + body);
	#endif
	bool res = commClient.send(body);
	return CommReceiveCommandResponse(response);
}

/**
 * @brief Make it similar to WebRequest
 * 
 * @param response 
 * @param command 
 * @param data 
 * @param retries 
 * @param retryInterval 
 * @return int 
 */
int CommRequest(string& response, string command, string data, int retries = 3, int retryInterval = 1000)
{
	string resp[];
	bool res = CommSendCommandSimple(resp, command, data, retries, retryInterval);
	if(res)
	{
		response = resp[1];
		return 200;
	}
	return -1;
}


void CommResetLastError()
{
	CommLastError = "";
}

string CommGetLastError()
{
	return CommLastError;
}

void PrintArrayInt(int &data[], string name = "")
{
	PrintFormat("BEGIN %s", name);
	int len = ArraySize(data);
	for(int i = 0; i < len; ++i)
	{
		PrintFormat("%d: %d", i, data[i]);
	}
	PrintFormat("END %s", name);
}
//#endregion

//#region Interface

interface IZmqSerializable
{
	bool Serialize(string& buffer[], int& currentPosition);
	bool Deserialize(string& buffer[], int& currentPosition);
	int Length(); //number of lines in buffer required
};


//#endregion

#endif