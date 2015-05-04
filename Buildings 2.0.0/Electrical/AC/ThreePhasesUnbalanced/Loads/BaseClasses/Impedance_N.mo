within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses;
partial model Impedance_N
  "Partial model of a three-phase unbalanced impedance with neutral cable"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.BaseImpedance;
  Interfaces.Terminal4_n terminal "Electrical connector"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.Connection3to4_n connection3to4
    "Connection from three-phase and neutral to three-phase" annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
equation

  connect(connection3to4.terminal3, wyeToDelta.wye) annotation (Line(
      points={{-68,6.66134e-16},{-68,10},{-64,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4.terminal3, wyeToWyeGround.wye) annotation (Line(
      points={{-68,4.44089e-16},{-68,-10},{-64,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4.terminal4, terminal) annotation (Line(
      points={{-88,0},{-100,0}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation (    Documentation(info="<html>
<p>
This model represents a partial interface for a three-phase AC
unbalanced impedance with a neutral cable. The current in the neutral
cable is computed as the algebraic sum of the currents in the loads.
</p>
<p>
The model can be configured in order to represent different type of
impedances as well as configurations.
</p>
<p>
The loads can be connected either in wye (Y) or delta (D) configuration.
The parameter <code>loadConn</code> can be used for such a purpose.
</p>
<p>
The model has three impedances that can be either connected in Y or
Delta configuration. The parameter <code>loadConn</code> can be used for
such a purpose. The Boolean parameter <code>inductive</code> can be selected
to specify the type of impedance.
</p>
<p>
The impedances on each phase can be removed using the boolean flags
<code>plugPhase1</code>, <code>plugPhase2</code>, and <code>plugPhase3</code>.
These parameters can be used to generate unbalanced loads.
</p>
<p>
The values of the impedances are computed starting from the parameters <code>R</code>,
<code>L</code>, and <code>C</code>. Depending on the values of the boolean flag
<code>inductive</code> some of these parameters may be disabled. There are additional
flags <code>use_R_in</code>, <code>use_L_in</code>, and <code>use_C_in</code> that can
be used to specify time varying impedances.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Created model from previus version.
</li>
</ul>
</html>"));
end Impedance_N;
