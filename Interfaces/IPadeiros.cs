using Baker_API.Views;

namespace Baker_API.Interfaces
{
    public interface IPadeiros
    {
        public List<PadeiroView> List(string CD_CIDADE);

    }
}
