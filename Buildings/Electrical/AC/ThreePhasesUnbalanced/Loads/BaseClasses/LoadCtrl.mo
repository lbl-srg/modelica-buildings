within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses;
partial model LoadCtrl
  "Partial model of a three-phase load with voltage controller without neutral cable"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.BaseLoadCtrl;
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_n terminal
    "Connector for three-phase unbalanced systems without neutral cable"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
equation

  connect(terminal, wyeToDelta.wye) annotation (Line(
      points={{-100,0},{-78,0},{-78,10},{-54,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal, wyeToWyeGround.wye) annotation (Line(
      points={{-100,0},{-78,0},{-78,-10},{-54,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (    Documentation(info="<html>
<p>
This model represents a partial interface for a three-phase AC unbalanced
load without neutral cable.
</p>
<p>
The loads on each phase can be removed using the boolean flags
<code>plugPhase1</code>, <code>plugPhase2</code>, and <code>plugPhase3</code>.
These parameters can be used to generate unbalanced loads.
</p>
<p>
The loads can be connected either in wye (Y) or delta (D) configuration.
The parameter <code>loadConn</code> can be used for such a purpose.
</p>
<p>
Each load model has the option to be controlled by a voltage controller.
When enabled, the voltage controller unplugs the load for a certain amount of
time if the voltage exceeds a given threshold. Mode information about the
voltage controller can be found
<a href=\"modelica://Buildings.Electrical.Utilities.VoltageControl\">here</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Revised model, it now extends from
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.PartialLoadCtrl\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.PartialLoadCtrl</a>.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end LoadCtrl;
