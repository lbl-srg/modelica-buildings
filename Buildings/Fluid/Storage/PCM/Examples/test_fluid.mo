within Buildings.Fluid.Storage.PCM.Examples;
model test_fluid
  extends Modelica.Icons.Example;
  replaceable package Medium =
        Buildings.Media.Water(cp_const=4000);
        Real cp = Medium.cp_const;
end test_fluid;
