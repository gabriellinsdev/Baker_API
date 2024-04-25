﻿namespace Baker_API.Domains
{
    public class ProdutoModel
    {
        public int CD_PRODUTO { get; set; }
        public Guid CD_USUARIO { get; set; }
        public string? NM_PRODUTO { get; set; }
        public string? DS_PRODUTO { get; set; }
        public decimal VL_PRECO { get; set; }
        public IFormFile FF_IMAGEM { get; set; }
        public byte[]? VB_IMAGEM { get; set; }
    }
}
