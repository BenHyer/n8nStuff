using RecipeTracker.Models;
using RecipeTracker.PageModels;

namespace RecipeTracker.Pages
{
    public partial class MainPage : ContentPage
    {
        public MainPage(MainPageModel model)
        {
            InitializeComponent();
            BindingContext = model;
        }
    }
}