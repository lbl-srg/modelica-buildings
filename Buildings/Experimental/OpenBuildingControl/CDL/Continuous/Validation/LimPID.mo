within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model LimPID "Test model for LimPID controller"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Pulse pulse(period=0.25)
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.LimPID limPID(
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PID,
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Buildings.Experimental.OpenBuildingControl.CDL.Types.Init.InitialState)
          annotation (Placement(transformation(extent={{16,-10},{36,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.LimPID limPIDOri(
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PID,
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Buildings.Experimental.OpenBuildingControl.CDL.Types.Init.InitialState)
          annotation (Placement(transformation(extent={{16,30},{36,50}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant const(k=0.5)
    annotation (Placement(transformation(extent={{-44,-40},{-24,-20}})));

equation
  connect(pulse.y, limPID.u_s) annotation (Line(
      points={{-23,0},{14,0}},
      color={0,0,127}));
  connect(const.y, limPID.u_m) annotation (Line(
      points={{-23,-30},{26,-30},{26,-12}},
      color={0,0,127}));
  connect(pulse.y, limPIDOri.u_s) annotation (Line(
      points={{-23,0},{-9.5,0},{-9.5,40},{14,40}},
      color={0,0,127}));
  connect(const.y, limPIDOri.u_m) annotation (Line(
      points={{-23,-30},{-16,-30},{-16,20},{26,20},{26,28}},
      color={0,0,127}));
 annotation (
 experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/LimPID.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.LimPID\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.LimPID</a>.
</p>

<p>
The model <code>limPIDOri</code> is the original
implementation of the controller from the Modelica
Standard Library. The models <code>limPID</code>
is the implementations from the Buildings library.
</p>
</html>", revisions="<html>
<ul>
<li>
March 24, 2017, by Jianjun Hu:<br/>
Added into CDL, simplified the validation model.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Relaxed tolerance of assertions from <i>1E-10</i>
to <i>1E-3</i> as the default relative tolerance in JModelica
is <i>1E-4</i>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/510\">
Buildings, issue 510</a>.
</li>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end LimPID;
