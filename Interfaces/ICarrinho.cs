﻿using Baker_API.Views;

namespace Baker_API.Interfaces
{
    public class ICarrinho
    {
        void Save(List<CarrinhoView> carrinho);
        List<CarrinhoView> List(Guid usuario);
    }
}
}
