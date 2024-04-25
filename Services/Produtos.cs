using Baker_API.Domains;
using Baker_API.Interfaces;
using Baker_API.Models;
using Baker_API.Views;
using System.Xml;

namespace Baker_API.Services
{
    public class Produtos : IProdutos
    {

        public void Insert(ProdutoView produto, IFormFile imagem)
        {
            try
            {
                Repository.ProdutoRepository rep = new Repository.ProdutoRepository();

                List<AlimentoRestritoView> Itens = produto.LS_ALIMENTO_RESTRITO;

                string? xmlAlimentoRestrito = GerarXml(Itens);

                rep.Insert(Converter(produto, imagem), xmlAlimentoRestrito);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void Update(ProdutoView produto, IFormFile imagem)
        {
            try
            {
                Repository.ProdutoRepository rep = new Repository.ProdutoRepository();

                List<AlimentoRestritoView> Itens = produto.LS_ALIMENTO_RESTRITO;

                string? xmlAlimentoRestrito = GerarXml(Itens);

                rep.Update(Converter(produto, imagem), xmlAlimentoRestrito);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void Delete(int CD_PRODUTO)
        {
            try
            {
                Repository.ProdutoRepository rep = new Repository.ProdutoRepository();
                rep.Delete(CD_PRODUTO);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<ProdutoView> List(Guid CD_USUARIO)
        {
            try
            {
                Repository.ProdutoRepository rep = new Repository.ProdutoRepository();

                List<ProdutoModel> lista = rep.List(CD_USUARIO);
                List<ProdutoView> ListaProdutos = new List<ProdutoView>();

                foreach (ProdutoModel produtoModel in lista)
                {
                    ProdutoView model = new ProdutoView();
                    model = Converter(produtoModel);

                    ListaProdutos.Add(model);
                }

                if (ListaProdutos.Count() == 0)
                {
                    return null;
                }

                return ListaProdutos;
            }
            catch (Exception)
            {
                throw;
            }
        }

        private ProdutoModel Converter(ProdutoView produto, IFormFile imagem)
        {
            ProdutoModel obj = new ProdutoModel();

            byte[] VB_IMAGEM = ConvertToByte(imagem);

            obj.CD_PRODUTO = produto.CD_PRODUTO;
            obj.DS_PRODUTO = produto.DS_PRODUTO;
            obj.NM_PRODUTO = produto.NM_PRODUTO;
            obj.VL_PRECO = produto.VL_PRECO;
            obj.CD_USUARIO = produto.CD_USUARIO;
            obj.VB_IMAGEM = VB_IMAGEM;

            foreach(AlimentoRestritoView lst in produto.LS_ALIMENTO_RESTRITO)
            {
                AlimentoRestritoModel model = new AlimentoRestritoModel();

                model.CD_ALIMENTO_RESTRITO = lst.CD_ALIMENTO_RESTRITO;
                model.DS_ALIMENTO_RESTRITO = lst.DS_ALIMENTO_RESTRITO;

                obj.LS_ALIMENTO_RESTRITO.Add(model);
            }

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
            obj.VB_IMAGEM = produto.VB_IMAGEM;

            foreach (AlimentoRestritoModel lst in produto.LS_ALIMENTO_RESTRITO)
            {
                AlimentoRestritoView view = new AlimentoRestritoView();

                view.CD_ALIMENTO_RESTRITO = lst.CD_ALIMENTO_RESTRITO;
                view.DS_ALIMENTO_RESTRITO = lst.DS_ALIMENTO_RESTRITO;

                obj.LS_ALIMENTO_RESTRITO.Add(view);
            }


            return obj;
        }

        private byte[] ConvertToByte(IFormFile imagem)
        {
            byte[] imagemBytes;
            using (var stream = imagem.OpenReadStream())
            {
                using (var memoryStream = new System.IO.MemoryStream())
                {
                    stream.CopyTo(memoryStream);
                    imagemBytes = memoryStream.ToArray();
                }
            }

            return imagemBytes;

        }

        private string? GerarXml(List<AlimentoRestritoView>? itens)
        {
            if (itens != null && itens.Count() > 0)
            {
                return XmlCreator(itens);
            }
            return null;
        }

        private string XmlCreator(List<AlimentoRestritoView> carrinhoItens)
        {
            // Criando um documento XML
            XmlDocument xmlDoc = new XmlDocument();

            // Criando o nó raiz
            XmlElement root = xmlDoc.CreateElement("AlimentoRestrito");
            xmlDoc.AppendChild(root);

            // Adicionando os itens do carrinho
            foreach (var item in carrinhoItens)
            {
                // Criando o nó do carrinho
                XmlElement carrinhoElement = xmlDoc.CreateElement("Item");
                root.AppendChild(carrinhoElement);

                // Adicionando os campos ao nó do carrinho
                XmlElement cdAlimentoRestritoElement = xmlDoc.CreateElement("CD_ALIMENTO_RESTRITO");
                cdAlimentoRestritoElement.InnerText = item.CD_ALIMENTO_RESTRITO.ToString();
                carrinhoElement.AppendChild(cdAlimentoRestritoElement);

            }

            // Salvar o XML para um arquivo ou imprimir na tela
            return xmlDoc.OuterXml;
        }

    }
}
