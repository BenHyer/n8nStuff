using System;
using System.Collections.Generic;
using System.Text;

namespace RecipeTracker.Models
{
    public class Recipe
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public List<string> Ingredients { get; set; }
        public List<string> Instructions { get; set; }
        public int PreparationTime { get; set; } // in minutes
        public int CookingTime { get; set; } // in minutes
        public int Servings { get; set; }
    }
}
