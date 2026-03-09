using System.Text;
using System.Text.Json;
namespace RecipeTracker.Services
{

public class N8nService
{
    private readonly HttpClient _httpClient;
    // Replace this with your actual tunnel URL from n8n
    private const string WebhookUrl = "http://localhost:5678/webhook-test/0d487f2d-c394-4d13-bfa6-7f7ec0723086";

    public N8nService()
    {
        _httpClient = new HttpClient();
    }

        public async Task<string?> SendDataToWorkflow(object data)
        {
            try
            {
                var json = JsonSerializer.Serialize(data);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await _httpClient.PostAsync(WebhookUrl, content);

                if (response.IsSuccessStatusCode)
                {
                    // Read the custom JSON message you wrote in the n8n Code Node
                    return await response.Content.ReadAsStringAsync();
                }
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Connection failed: {ex.Message}");
                return null;
            }
        }
    }
}
