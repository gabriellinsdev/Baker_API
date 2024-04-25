using Baker_API.Domains;

namespace Baker_API.Repository
{
    public class ProdutoRepository
    {
        const string dbName = "DB_BAKER";

        public void Insert(ProdutoModel produto, string? xmlAlimentoRestrito)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spINSProduto", new
            {
                produto.CD_PRODUTO,
                produto.CD_USUARIO,
                produto.NM_PRODUTO,
                produto.DS_PRODUTO,
                produto.VL_PRECO,
                produto.VB_IMAGEM,
                PRODUTOS_RESTRITOS = xmlAlimentoRestrito
            });
        }

        public void Update(ProdutoModel produto, string? xmlAlimentoRestrito)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spUPDProduto", new
            {
                produto.CD_PRODUTO,
                produto.CD_USUARIO,
                produto.NM_PRODUTO,
                produto.DS_PRODUTO,
                produto.VL_PRECO,
                produto.VB_IMAGEM,
                PRODUTOS_RESTRITOS = xmlAlimentoRestrito
            });
        }

        public void Delete(int CD_PRODUTO)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spDELProduto", new
            {
                CD_PRODUTO
            });

        }

        public List<ProdutoModel> List(Guid CD_USUARIO)
        {
            Helper helper = new Helper();
            return helper.ExecuteList<ProdutoModel>(dbName, "dbo.spLSTProduto", new
            {
                CD_USUARIO
            });

        }
    }
}
