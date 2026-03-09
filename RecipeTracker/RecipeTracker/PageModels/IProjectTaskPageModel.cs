using CommunityToolkit.Mvvm.Input;
using RecipeTracker.Models;

namespace RecipeTracker.PageModels
{
    public interface IProjectTaskPageModel
    {
        IAsyncRelayCommand<ProjectTask> NavigateToTaskCommand { get; }
        bool IsBusy { get; }
    }
}