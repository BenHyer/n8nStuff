using CommunityToolkit.Mvvm.ComponentModel;
using RecipeTracker.Services;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json;


namespace RecipeTracker.PageModels
{
    
    public partial class NewRecipeViewModel : ObservableObject
    {
        [ObservableProperty]
        private string name;

        [ObservableProperty]
        private string description;

        [ObservableProperty]
        private string ingredients;

        [ObservableProperty]
        private string instructions;

        [ObservableProperty]
        private string preparationTime;

        [ObservableProperty]
        private string cookingTime;

        [ObservableProperty]
        private string servings;

        public NewRecipeViewModel()
        {
            SaveRecipeCommand = new CommunityToolkit.Mvvm.Input.AsyncRelayCommand(SaveRecipeAsync);
        }

        public CommunityToolkit.Mvvm.Input.IAsyncRelayCommand SaveRecipeCommand { get; }

        private async Task SaveRecipeAsync()
        {
            // 1. Capture the current Name before we do anything (for the alert)
            string recipeName = Name;

            var recipe = new Models.Recipe
            {
                Name = Name,
                Description = Description,
                Ingredients = string.IsNullOrWhiteSpace(Ingredients) ? new List<string>() : new List<string>(Ingredients.Split(',')),
                Instructions = string.IsNullOrWhiteSpace(Instructions) ? new List<string>() : new List<string>(Instructions.Split(',')),
                PreparationTime = int.TryParse(PreparationTime, out var prep) ? prep : 0,
                CookingTime = int.TryParse(CookingTime, out var cook) ? cook : 0,
                Servings = int.TryParse(Servings, out var serv) ? serv : 0
            };

            var n8nService = new Services.N8nService();
            var result = await n8nService.SendDataToWorkflow(recipe);

            if (result != null)
            {
                // If we get here, n8n accepted the data!
                await Shell.Current.DisplayAlert("Success", $"Recipe '{recipeName}' sent successfully!", "OK");

                
            }
            else
            {
                await Shell.Current.DisplayAlert("Error", "Could not reach n8n. Is the tunnel running?", "OK");
            }
        }
    }
}
