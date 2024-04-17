using Baker_API.Domains;

namespace Baker_API.Repository
{
    public class ProdutoRepository
    {

        public void Insert(ProdutoDomain produto)
        {
            string x = string.Format("exec dbo.spINSProduto {0}{1}{2}{3}{4}{5}", produto.CD_PRODUTO, produto.CD_USUARIO);

        }

    }
}
