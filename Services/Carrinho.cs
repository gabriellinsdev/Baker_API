using Baker_API.Interfaces;
using Baker_API.Models;
using Baker_API.Views;

namespace Baker_API.Services
{
    public class Carrinho: ICarrinho
    {
        public void Save(List<CarrinhoView> carrinho)
        {
            try
            {
                Repository.CarrinhoRepository rep = new Repository.CarrinhoRepository();
                rep.Save(Converter(carrinho));
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<CarrinhoView> List(Guid CD_USUARIO)
        {
            try
            {
                Repository.CarrinhoRepository rep = new Repository.CarrinhoRepository();

                List<CarrinhoModel> lista = rep.List(CD_USUARIO);
                List<CarrinhoView> Listacarrinhos = new List<CarrinhoView>();

                foreach (CarrinhoModel carrinhoModel in lista)
                {
                    CarrinhoView model = new CarrinhoView();
                    model = Converter(carrinhoModel);

                    Listacarrinhos.Add(model);
                }

                if (Listacarrinhos.Count() == 0)
                {
                    return null;
                }

                return Listacarrinhos;
            }
            catch (Exception)
            {
                throw;
            }
        }

    }
}
