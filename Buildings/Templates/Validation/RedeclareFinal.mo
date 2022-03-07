within Buildings.Templates.Validation;
model RedeclareFinal
  extends Modelica.Icons.Example;
  record A
    final parameter Integer p = 1;
  end A;

  record B
    final parameter Integer p = 2;
  end B;

  model One
    redeclare parameter A a;
  end One;

  One redeclar(redeclare B a);

  parameter B b;

  One bind(a=b);

end RedeclareFinal;
