
namespace RaceDay.API.Models
{
    public class Category
    {
        public int CategoryID { get; set; }
        public int EventID { get; set; }
        public string CategoryName { get; set; } = "";
        public decimal Distance { get; set; }
        public int AgeMin { get; set; }
        public int AgeMax { get; set; }
        public decimal EntryFee { get; set; }
    }
}
