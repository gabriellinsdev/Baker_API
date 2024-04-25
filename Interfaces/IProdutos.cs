using Baker_API.Views;

namespace Baker_API.Interfaces
{
    public interface IProdutos
    {
        public void Insert(ProdutoView produtos, IFormFile imagem);

        public void Update(ProdutoView produtos, IFormFile imagem);

        public void Delete(int idProduto);

        public List<ProdutoView> List(Guid usuario);
    }
}
