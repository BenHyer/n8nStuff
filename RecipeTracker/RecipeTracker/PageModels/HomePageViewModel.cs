using CommunityToolkit.Mvvm.ComponentModel;
using System;
using System.Collections.Generic;
using System.Text;

namespace RecipeTracker.PageModels
{
    public partial class HomePageViewModel : ObservableObject
    {
        public HomePageViewModel()
        {
            AddNewRecipeCommand = new CommunityToolkit.Mvvm.Input.AsyncRelayCommand(OnAddNewRecipe);
        }

        public CommunityToolkit.Mvvm.Input.IAsyncRelayCommand AddNewRecipeCommand { get; }

        private async Task OnAddNewRecipe()
        {
            await Shell.Current.GoToAsync("///newrecipe");
        }
    }
}
