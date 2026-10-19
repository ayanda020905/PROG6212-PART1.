
namespace RaceDay.API.Models
{
    public class Enrolment
    {
        public int EnrolmentID { get; set; }
        public int EventID { get; set; }
        public int ParticipantID { get; set; }
        public DateTime EnrolmentDate { get; set; }
        public int RaceNumber { get; set; }
        public string PaymentStatus { get; set; } = "";
    }
}
