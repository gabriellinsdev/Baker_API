using System.Runtime.Serialization;

namespace Baker_API.Views
{
    public class LocalizacaoView
    {
        [DataMember]
        public Guid? CD_USUARIO { get; set; }
        [DataMember]
        public string? NM_USUARIO { get; set; }
        [DataMember]
        public string? NM_CIDADE { get; set; }
        [DataMember]
        public double CD_LATITUDE { get; set; }        
        [DataMember]
        public double CD_LONGITUDE { get; set; }
        [DataMember]
        public string? DS_MENSAGEM { get; set; }
    }
}
