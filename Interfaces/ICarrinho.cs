using Baker_API.Views;

namespace Baker_API.Interfaces
{
    public interface ICarrinho
    {
        void Save(CarrinhoView carrinho);
        void Delete(Guid CD_USUARIO, int CD_PRODUTO);
        List<CarrinhoView> List(Guid CD_USUARIO);
    }
}

