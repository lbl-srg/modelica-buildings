within Buildings.Utilities.IO.SignalExchange.Examples.BaseClasses;
model ExportedModel "Model to be exported as an FMU"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput oveWriSet_u "Signal for overwrite block for set point"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.BooleanInput oveWriSet_activate "Activation for overwrite block for set point"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput oveWriAct_u "Signal for overwrite block for actuator signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.BooleanInput oveWriAct_activate "Activation for overwrite block for actuator signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput rea = mod.rea.y
    "Measured state variable"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  BaseClasses.OriginalModel mod(
      oveWriSet(
        uExt(
          y=oveWriSet_u),
        activate(
          y=oveWriSet_activate)),
      oveWriAct(
        uExt(
          y=oveWriAct_u),
        activate(
          y=oveWriAct_activate))) "Original model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

annotation(Documentation(info="<html>
<p>
This is an example of a model that would be compiled in BOPTEST if the
original model were using the signal exchange blocks. Note that inputs
are added to activate and set values of control signals that can be overwritten
and outputs are added to read signals from the read blocks.
</p>
</html>", revisions="<html>
<ul>
<li>
December 17, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExportedModel;
