within Districts.Electrical.AC.Loads.BaseClasses;
partial model SeriesConnections "Interface for a single phase component"
  import Modelica.ComplexMath.conj;
  parameter Boolean measureP = false "This flag activate the power output" annotation(evaluate=true, Dialog(tab = "Outputs"));
  parameter Boolean measureI = false
    "This flag activate the complex current output"  annotation(evaluate=true, Dialog(tab = "Outputs"));
  parameter Boolean measureV = false
    "This flag activate the complex voltage output"  annotation(evaluate=true, Dialog(tab = "Outputs"));
  Modelica.SIunits.ComplexVoltage  v;
  Modelica.SIunits.ComplexCurrent  i;
  Modelica.SIunits.AngularVelocity omega = der(sPhasePlug.phase[1].reference.gamma);
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
  Modelica.ComplexBlocks.Interfaces.ComplexOutput va if measureP
    "Complex power"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-74,-64}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-50})));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput amp if measureI
    "Complex current"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-54,-64}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,-50})));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput volt if measureV
    "Complex voltage"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-34,-64}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-50})));
protected
  Districts.Electrical.AC.Interfaces.PowerOutput P_in;
  Modelica.ComplexBlocks.Interfaces.ComplexOutput va_in;
  Modelica.ComplexBlocks.Interfaces.ComplexOutput amp_in;
  Modelica.ComplexBlocks.Interfaces.ComplexOutput volt_in;
equation

  connect(P,P_in);
  connect(va_in,va);
  connect(amp_in,amp);
  connect(volt_in,volt);

  if measureP then
    P_in.real = abs(va_in.re);
    P_in.apparent=(va_in.re^2 + va_in.im^2)^0.5;
    P_in.phi=Modelica.Math.atan2(va_in.im,va_in.re);
    P_in.cosPhi=Modelica.Math.cos(P_in.phi);
    va_in = v*conj(i);
  else
    P_in.real = 0;
    P_in.apparent = 0;
    P_in.phi = 0;
    P_in.cosPhi = 0;
    va_in = Complex(0);
  end if;

  if measureV then
    volt_in = v;
  else
    volt_in = Complex(0);
  end if;

  if measureI then
    amp_in  = i;
  else
    amp_in  = Complex(0);
  end if;

  Connections.branch(sPhasePlug.phase[1].reference, sPhasePlug.neutral.reference);
  sPhasePlug.phase[1].reference.gamma = sPhasePlug.neutral.reference.gamma;

  i = sPhasePlug.phase[1].i;
  v = sPhasePlug.phase[1].v - sPhasePlug.neutral.v;

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
end SeriesConnections;
