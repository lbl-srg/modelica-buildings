within Districts.Electrical.AC.Transmission;
model Line "Cable line dispersion model"
  parameter Modelica.SIunits.Distance Length(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V "Nominal voltage of the line";

  parameter Boolean useExtTemp = false
    "If =true, enables the input for the temperature of the cable" annotation(Dialog(tab="Model"));
  parameter Modelica.SIunits.Temperature Tcable = T_ref
    "Fixed temperature of the cable" annotation(Dialog(tab="Model", enable = not useExtTemp));
  parameter Districts.Electrical.AC.Transmission.Cables.Cable cable=
      Districts.Electrical.AC.Transmission.Functions.choseCable(P, V)
    "Type of cable"
  annotation (Evaluate=true, choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{20,60},
            {40,80}})));
  parameter Districts.Electrical.AC.Transmission.Materials.Material wireMaterial = Districts.Electrical.AC.Transmission.Functions.choseMaterial(0.0)
    "Material of the cable"
    annotation (Evaluate=true, choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{60,60},
            {80,80}})));
  final parameter Modelica.SIunits.Temperature T_ref=wireMaterial.T0
    "Reference temperature of the line" annotation(Evaluate=True);
  final parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=wireMaterial.alphaT0
    "Linear temperature coefficient of the material"                                                                                         annotation(Evaluate=True);
  final parameter Modelica.SIunits.Resistance R = wireMaterial.r0*Length/(cable.S*1e6)
    "Resistance of the cable";
  final parameter Modelica.SIunits.Inductance L = Length*(0.055 - 0.4606*log(cable.d/2) + 0.4606*log(2*cable.i))*1e-3/1e3
    "Inductance of the cable due to mutual and self inductance" annotation(Evaluate = True);
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor
                                            resistorLine(R_ref=R,
    T_ref=T_ref,
    alpha_ref=alpha,
    useHeatPort=true)
    annotation (Placement(transformation(extent={{-40,10},{-20,-10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Inductor
                                            inductorLine(L=L)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
                 A
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin
                 B
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature cableTemp
    "Temperature of the cable"
    annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
  Modelica.Blocks.Interfaces.RealInput T if useExtTemp
    "Temperature of the cable"                                                    annotation (
     Placement(transformation(extent={{-42,28},{-2,68}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,30})));
protected
  Modelica.Blocks.Interfaces.RealInput T_in;
public
  Modelica.Blocks.Sources.RealExpression cableTemperature(y=T_in)
    annotation (Placement(transformation(extent={{-92,12},{-72,32}})));
equation

  connect(T_in, T);

  if not useExtTemp then
    T_in = Tcable;
  end if;

  connect(A, resistorLine.pin_p) annotation (Line(
      points={{-100,0},{-40,0}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(resistorLine.pin_n, inductorLine.pin_p) annotation (Line(
      points={{-20,0},{20,0}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(inductorLine.pin_n, B) annotation (Line(
      points={{40,0},{100,0}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(cableTemp.port, resistorLine.heatPort) annotation (Line(
      points={{-40,22},{-30,22},{-30,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cableTemperature.y, cableTemp.T) annotation (Line(
      points={{-71,22},{-62,22}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-72,10},{-52,-10}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,10},{58,-10}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{48,10},{68,-10}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-72,0},{-92,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-62,10},{58,10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-62,-10},{58,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{94,0},{58,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{14,40},{40,16}},
          lineColor={0,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T")}));
end Line;
