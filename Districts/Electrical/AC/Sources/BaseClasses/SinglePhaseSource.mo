within Districts.Electrical.AC.Sources.BaseClasses;
partial model SinglePhaseSource "Interface for a single phase component"
  import Modelica.ComplexMath.conj;
  parameter Boolean measureP = false "This flag activate the power output" annotation(evaluate=true, Dialog(tab = "Outputs"));
  Modelica.SIunits.ComplexVoltage  v;
  Modelica.SIunits.ComplexCurrent  i;
  Modelica.SIunits.AngularVelocity omega = der(sPhasePlug.p[1].reference.gamma);
  Districts.Electrical.AC.Interfaces.SinglePhasePlug sPhasePlug
    "Single phase connector"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Districts.Electrical.AC.Interfaces.PowerOutput P if measureP
    "Power consumed from grid if negative, or fed to grid if positive"                                             annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=270,
        origin={66,-66}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-50})));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput A if measureP "Complex power"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-74,-64}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-50})));
protected
  Districts.Electrical.AC.Interfaces.PowerOutput P_in;
  Modelica.ComplexBlocks.Interfaces.ComplexOutput A_in;
equation

  connect(P,P_in);
  connect(A,A_in);

  if measureP then
    P_in.real = abs(A_in.re);
    P_in.apparent=(A_in.re^2 + A_in.im^2)^0.5;
    P_in.phi=Modelica.Math.atan2(A_in.im,A_in.re);
    P_in.cosPhi=Modelica.Math.cos(P_in.phi);
    A_in = v*conj(i);
  else
    P_in.real = 0;
    P_in.apparent = 0;
    P_in.phi = 0;
    P_in.cosPhi = 0;
    A_in = Complex(0);
  end if;

  Connections.branch(sPhasePlug.p[1].reference, sPhasePlug.n.reference);
  sPhasePlug.p[1].reference.gamma = sPhasePlug.n.reference.gamma;
  i = sPhasePlug.p[1].i;
  v = sPhasePlug.p[1].v - sPhasePlug.n.v;

  annotation (         Documentation(info="<html>
<p>
This partial model uses a <a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin\">positive</a>
and <a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin\">negative pin</a> and defines the complex voltage difference as well as the complex current (into the positive pin). Additionally, the angular velocity of the quasi stationary system is explicitely defined as variable. This model is mainly intended to be used with graphical representation of user models.
</p>

<h4>See also</h4>

<p>
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin\">PositivePin</a>,
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin\">NegativePin</a>,
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.OnePort\">OnePort</a>
</p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end SinglePhaseSource;
