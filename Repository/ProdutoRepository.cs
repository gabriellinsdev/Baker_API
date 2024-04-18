using Baker_API.Domains;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Baker_API.Repository
{
    public class ProdutoRepository
    {
        const string dbName = "Baker";

        public void Inserir(ProdutoDomain produto)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spINSProduto", new
            {
                produto.CD_PRODUTO,
                produto.CD_USUARIO,
                produto.NM_PRODUTO,
                produto.DS_CAMINHO_IMAGEM,
                produto.DS_PRODUTO,
                produto.VL_PRECO 
            });

        }

        public void Alterar(ProdutoDomain produto)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spUPDProduto", new
            {
                produto.CD_PRODUTO,
                produto.CD_USUARIO,
                produto.NM_PRODUTO,
                produto.DS_CAMINHO_IMAGEM,
                produto.DS_PRODUTO,
                produto.VL_PRECO
            });
        }

        public void Excluir(ProdutoDomain produto)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spDELProduto", new
            {
                produto.CD_PRODUTO,
                produto.CD_USUARIO,
                produto.NM_PRODUTO,
                produto.DS_CAMINHO_IMAGEM,
                produto.DS_PRODUTO,
                produto.VL_PRECO
            });

        }

        public List<ProdutoDomain> Listar(ProdutoDomain produto)
        {
            Helper helper = new Helper();
            return helper.ExecuteList<ProdutoDomain>(dbName, "dbo.spLSTProduto", new
            {
                produto.CD_PRODUTO,
                produto.CD_USUARIO,
                produto.NM_PRODUTO,
                produto.DS_CAMINHO_IMAGEM,
                produto.DS_PRODUTO,
                produto.VL_PRECO
            });

        }
    }
}
