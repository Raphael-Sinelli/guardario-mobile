// Item do kit de emergência. `pronto` muda quando a pessoa marca o item.
class ItemKit {
  final String nome;
  bool pronto;

  ItemKit(this.nome, {this.pronto = false});
}
