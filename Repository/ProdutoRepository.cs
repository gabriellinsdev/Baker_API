using Baker_API.Domains;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Baker_API.Repository
{
    public class ProdutoRepository
    {
        const string dbName = "DB_BAKER";

        public void Insert(ProdutoModel produto)
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

        public void Update(ProdutoModel produto)
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

        public void Delete(int idProduto)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spDELProduto", new
            {
                CD_PRODUTO = idProduto
            });

        }

        public List<ProdutoModel> List(Guid usuario)
        {
            Helper helper = new Helper();
            return helper.ExecuteList<ProdutoModel>(dbName, "dbo.spLSTProduto", new
            {
                CD_USUARIO = usuario
            });

        }
    }
}
