within Buildings.Templates;
model FinalModification
  extends Modelica.Icons.Example;

  model M1
    final parameter Integer myPar = 1;
  end M1;

  model M2
    final parameter Integer myPar = 2;
  end M2;

  model A
    replaceable M1 m;
  end A;

  model B = A(redeclare M2 m);

  B b;

  record R1
    parameter Integer myPar = 1;
  end R1;

  record R2
    final parameter Integer myPar = 2;
  end R2;

  model U
    parameter R1 r(final myPar=1);
  end U;

  model V = U(r=R2());

  V v;

end FinalModification;
