
namespace RaceDay.API.Models
{
    public class Event
    {
        public int EventID { get; set; }
        public int OrganiserID { get; set; }
        public string EventName { get; set; } = "";
        public string Description { get; set; } = "";
        public DateTime EventDate { get; set; }
        public string Location { get; set; } = "";
        public decimal Distance { get; set; }
        public decimal EntryFee { get; set; }
        public string Status { get; set; } = "";
    }
}
