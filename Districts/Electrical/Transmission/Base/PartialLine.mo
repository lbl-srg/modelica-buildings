within Districts.Electrical.Transmission.Base;
partial model PartialLine "Cable line dispersion model"
  extends Districts.Electrical.Interfaces.PartialTwoPort(
    terminal_n(i[:](each nominal=P_nominal/V_nominal),
               v[:](each nominal=V_nominal)),
    terminal_p(i[:](each nominal=P_nominal/V_nominal),
               v[:](each nominal=V_nominal)));
  parameter Modelica.SIunits.Distance l(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P_nominal(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)
    "Nominal voltage of the line";

  parameter Boolean useC = false
    "Select if choosing the capacitive effect of the cable or not"
    annotation(Dialog(tab="Model"));
  parameter Boolean useExtTemp = false
    "If true, enables the input for the temperature of the cable" annotation(evaluate = true, Dialog(tab="Model"));
  parameter Modelica.SIunits.Temperature Tcable = T_ref
    "Fixed temperature of the cable" annotation(Dialog(tab="Model", enable = not useExtTemp));

  parameter Districts.Electrical.Types.CableMode mode=
    Districts.Electrical.Types.CableMode.automatic
    "Select if choosing the cable automatically or between a list of commercial options"
    annotation(Dialog(tab="Tech. specification"), choicesAllMatching=true);

  parameter Districts.Electrical.Transmission.CommercialCables.Cable commercialCable=
     Districts.Electrical.Transmission.Functions.selectCable(wireMaterial, P_nominal, V_nominal)
    "List of various commercial cables"
    annotation(Dialog(tab="Tech. specification", enable = mode == Districts.Electrical.Types.CableMode.commercial),
               choicesAllMatching = true);

  parameter Districts.Electrical.Transmission.Materials.Material wireMaterial=
    Districts.Electrical.Transmission.Materials.Material.Cu
    "Material of the cable"
    annotation (choicesAllMatching=true,Dialog(tab="Tech. specification",
                enable = mode==Districts.Electrical.Types.CableMode.automatic),
                Placement(transformation(extent={{60,60}, {80,80}})));
  final parameter Modelica.SIunits.Temperature T_ref = commercialCable.T0
    "Reference temperature of the line" annotation(Evaluate=True);
  final parameter Modelica.SIunits.LinearTemperatureCoefficient alpha = commercialCable.alphaT0
    "Linear temperature coefficient of the material"                                                                                         annotation(Evaluate=True);
  final parameter Modelica.SIunits.Resistance R=
  Districts.Electrical.Transmission.Functions.lineResistance(l, commercialCable)
    "Resistance of the cable" annotation(Evaluate=True);
  final parameter Modelica.SIunits.Inductance L=
  Districts.Electrical.Transmission.Functions.lineInductance(l, commercialCable)
    "Inductance of the cable due to mutual and self inductance" annotation(Evaluate = True);

  //Real IPerANor(unit="A/m2", displayUnit="A/(mm.mm)") = terminal_n.PhaseSystem.systemCurrent(terminal_n.i) / cable.S "Current density";
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
  assert(L>=0, "The inductance of the cable is negative, check cable properties and size");
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
          textString="T"),
          Text(
            extent={{-150,-19},{150,-59}},
            lineColor={0,0,0},
          textString="%name")}));
end PartialLine;
