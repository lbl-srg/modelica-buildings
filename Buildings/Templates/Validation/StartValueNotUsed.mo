within Buildings.Templates.Validation;
model StartValueNotUsed
  extends Modelica.Icons.Example;

  record Data
    parameter Real notUsed(min=0)=-1;
    parameter Real used;
  end Data;

  model System
    parameter Data dat;
    final parameter Real used=dat.used;
  end System;

  parameter Data dat(used=1);

  System sys(final dat=dat);
end StartValueNotUsed;
