within Districts.Electrical.Transmission.Base;
partial model PartialLine "Cable line dispersion model"
  extends Districts.Electrical.Interfaces.PartialTwoPort;
  parameter Modelica.SIunits.Distance Length(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P_nominal(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V_nominal "Nominal voltage of the line";

  parameter Boolean useExtTemp = false
    "If =true, enables the input for the temperature of the cable" annotation(Dialog(tab="Model"));
  parameter Modelica.SIunits.Temperature Tcable = T_ref
    "Fixed temperature of the cable" annotation(Dialog(tab="Model", enable = not useExtTemp));
  parameter Districts.Electrical.Transmission.Cables.Cable cable=
      Functions.selectCable(P_nominal, V_nominal) "Type of cable"
  annotation (choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{20,60},
            {40,80}})));
  parameter Districts.Electrical.Transmission.Materials.Material wireMaterial=
      Functions.selectMaterial(0.0) "Material of the cable"
    annotation (choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{60,60},
            {80,80}})));
  final parameter Modelica.SIunits.Temperature T_ref=wireMaterial.T0
    "Reference temperature of the line" annotation(Evaluate=True);
  final parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=wireMaterial.alphaT0
    "Linear temperature coefficient of the material"                                                                                         annotation(Evaluate=True);
  final parameter Modelica.SIunits.Resistance R = wireMaterial.r0*Length/(cable.S*1e6)
    "Resistance of the cable" annotation(Evaluate=True);
  final parameter Modelica.SIunits.Inductance L = Length*(0.055 - 0.4606*log(cable.d/2) + 0.4606*log(2*cable.i))*1e-3/1e3
    "Inductance of the cable due to mutual and self inductance" annotation(Evaluate = True);
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

  connect(cableTemperature.y, cableTemp.T) annotation (Line(
      points={{-71,22},{-62,22}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{14,40},{40,16}},
          lineColor=DynamicSelect({0,0,255}, if useExtTemp then {0,0,255} else {255,255,
              255}),
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T")}));
end PartialLine;
