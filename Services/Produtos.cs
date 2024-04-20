using Baker_API.Domains;
using Baker_API.Interfaces;
using Baker_API.Views;

namespace Baker_API.Services
{
    public class Produtos: IProdutos
    {

        public void Insert(ProdutoView produto)
        {
            Repository.ProdutoRepository rep = new Repository.ProdutoRepository();
            rep.Insert(Converter(produto));
        }

        public void Update(ProdutoView produto)
        {
            Repository.ProdutoRepository rep = new Repository.ProdutoRepository();
            rep.Update(Converter(produto));
        }

        public void Delete(int idProduto)
        {
            Repository.ProdutoRepository rep = new Repository.ProdutoRepository();
            rep.Delete(idProduto);
        }

        public List<ProdutoView> List(Guid idUsuario)
        {
            Repository.ProdutoRepository rep = new Repository.ProdutoRepository();

            List<ProdutoModel> lista = rep.List(idUsuario);
            List<ProdutoView> produtos = new List<ProdutoView>();

            foreach (ProdutoModel produtoModel in lista)
            {
                ProdutoView model = new ProdutoView();
                model = Converter(produtoModel);

                produtos.Add(model);
            }

            return produtos;
        }

        private ProdutoModel Converter(ProdutoView produto)
        {
            ProdutoModel obj = new ProdutoModel();

            obj.CD_PRODUTO = produto.CD_PRODUTO;
            obj.DS_PRODUTO = produto.DS_PRODUTO;
            obj.NM_PRODUTO = produto.NM_PRODUTO;
            obj.VL_PRECO = produto.VL_PRECO;
            obj.CD_USUARIO = produto.CD_USUARIO;
            obj.DS_CAMINHO_IMAGEM = produto.DS_CAMINHO_IMAGEM;

            return obj;
        }

        private ProdutoView Converter(ProdutoModel produto)
        {
            ProdutoView obj = new ProdutoView();

            obj.CD_PRODUTO = produto.CD_PRODUTO;
            obj.DS_PRODUTO = produto.DS_PRODUTO;
            obj.NM_PRODUTO = produto.NM_PRODUTO;
            obj.VL_PRECO = produto.VL_PRECO;
            obj.CD_USUARIO = produto.CD_USUARIO;
            obj.DS_CAMINHO_IMAGEM = produto.DS_CAMINHO_IMAGEM;

            return obj;
        }
    }
}
