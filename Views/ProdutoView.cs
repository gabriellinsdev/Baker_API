using System.Runtime.Serialization;

namespace Baker_API.Views
{
    public class ProdutoView
    {
        [DataMember]
        public int CD_PRODUTO { get; set; }
        [DataMember]
        public Guid CD_USUARIO { get; set; }
        [DataMember]
        public string NM_PRODUTO { get; set; }
        [DataMember]
        public string DS_PRODUTO { get; set; }
        [DataMember]
        public decimal VL_PRECO { get; set; }
        [DataMember]
        public byte[]? VB_IMAGEM { get; set; } = null;
        [DataMember]
        public List<AlimentoRestritoView>? LS_ALIMENTO_RESTRITO { get; set; }
    }
}
