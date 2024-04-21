using Baker_API.Domains;

namespace Baker_API.Repository
{
    public class CarrinhoRepository
    {
        const string dbName = "DB_BAKER";

        public void Save(ProdutoModel produto)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spINSCarrinho", new
            {
                produto.CD_PRODUTO,
                produto.CD_USUARIO,
                produto.NM_PRODUTO,
                produto.DS_CAMINHO_IMAGEM,
                produto.DS_PRODUTO,
                produto.VL_PRECO
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
