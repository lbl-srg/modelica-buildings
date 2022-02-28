within Buildings.Templates.Validation;
model RecordConstructor
  extends Modelica.Icons.Example;

  record Data
    parameter Integer typ;
  end Data;

  model Model
    parameter Data dat(typ=1);
    parameter Integer typSec=2;
  end Model;

  Model mod;
  Data dat=Data(mod.dat);

end RecordConstructor;
