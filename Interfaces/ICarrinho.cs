using Baker_API.Views;

namespace Baker_API.Interfaces
{
    public interface ICarrinho
    {
        void Save(List<CarrinhoView> carrinho);
        List<CarrinhoView> List(Guid CD_USUARIO);
    }
}

