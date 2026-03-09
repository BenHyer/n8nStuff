namespace RecipeTracker.Pages;

public partial class NewRecipe : ContentPage
{
	public NewRecipe(NewRecipeViewModel vm)
	{
		InitializeComponent();
		BindingContext = vm;
    }
}