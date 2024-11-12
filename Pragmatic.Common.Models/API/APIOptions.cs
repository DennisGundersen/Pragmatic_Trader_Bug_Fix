namespace Pragmatic.Common.Models.API
{
    // Stores API address for simple update in appsettings.json rather than individual pages (registered in DI)
    public class APIOptions
    {
        public string BaseAddress { get; set; }
    }
}
