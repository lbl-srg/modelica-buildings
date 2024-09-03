within Buildings.Examples.Tutorial.CDL.Controls.Validation;
model SystemOnOff
  "Validation model for the system on/off controller"
    extends Modelica.Icons.Example;

  Buildings.Examples.Tutorial.CDL.Controls.SystemOnOff
    conSysSta "Controller for system on/off"
              annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOut(
    amplitude=5,
    freqHz=1/720,
    offset=290.15) "Outside air temperature"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TRoo(
    amplitude=4,
    freqHz=1/720,
    phase=1.5707963267949,
    offset=293.15) "Room air temperature"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(TOut.y, conSysSta.TOut) annotation (Line(points={{-38,20},{-20,20},{-20,
          6},{-2,6}}, color={0,0,127}));
  connect(TRoo.y, conSysSta.TRoo) annotation (Line(points={{-38,-20},{-20,-20},{
          -20,-6},{-2,-6}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Validation model for the system on/off controller.
The input to the controller are time varying signals for the outdoor air temperature
and the room air temperature.
The validation shows that the system is commanded on (<code>onSys=true</code>) if
the outdoor air temperature and the room air temperature are both low.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/CDL/Controls/Validation/SystemOnOff.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06));
end SystemOnOff;
