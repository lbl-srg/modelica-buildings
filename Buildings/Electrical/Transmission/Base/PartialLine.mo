within Buildings.Electrical.Transmission.Base;
partial model PartialLine "Cable line dispersion model"
  extends Buildings.Electrical.Interfaces.PartialTwoPort(terminal_n(i(nominal=
            nominal_i_), v(nominal=nominal_v_)), terminal_p(i(nominal=
            nominal_i_), v(nominal=nominal_v_)));

protected
  parameter Integer n_ = size(terminal_n.i,1);
  parameter Real nominal_i_ = P_nominal / V_nominal;
  parameter Real nominal_v_ = V_nominal;

public
  parameter Modelica.SIunits.Distance l(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P_nominal(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)
    "Nominal voltage of the line";

  parameter Boolean useC = false
    "Select if choosing the capacitive effect of the cable or not"
    annotation(Dialog(tab="Model", group="Assumptions"));
  parameter Buildings.Electrical.Types.Assumption modelMode=Types.Assumption.FixedZ_steady_state
    "Select between steady state and dynamic model"
    annotation(Dialog(tab="Model", group="Assumptions", enable = useC), choices(choice=Districts.Electrical.Types.Assumption.FixedZ_steady_state
        "Steady state", choice=Districts.Electrical.Types.Assumption.FixedZ_dynamic "Dynamic"));

  parameter Boolean useExtTemp = false
    "If true, enables the input for the temperature of the cable" annotation(evaluate = true, Dialog(tab="Model", group="Thermal"));
  parameter Modelica.SIunits.Temperature Tcable = T_ref
    "Fixed temperature of the cable" annotation(Dialog(tab="Model", group="Thermal", enable = not useExtTemp));

  parameter Buildings.Electrical.Types.CableMode mode=Types.CableMode.automatic
    "Select if choosing the cable automatically or between a list of commercial options"
    annotation(Dialog(tab="Tech. specification", group="Auto/Manual mode"), choicesAllMatching=true);

  parameter Buildings.Electrical.Types.VoltageLevel voltageLevel=
      Functions.selectVoltageLevel(V_nominal) "Select the voltage level"
    annotation(Dialog(tab="Tech. specification", group="Manual mode", enable = mode == Districts.Electrical.Types.CableMode.commercial),
               choicesAllMatching = true);

  parameter Buildings.Electrical.Transmission.LowVoltageCables.Cable commercialCable_low=
      Functions.selectCable_low(P_nominal, V_nominal)
    "List of Low voltage commercial cables"
    annotation(Dialog(tab="Tech. specification", group="Manual mode", enable = mode == Districts.Electrical.Types.CableMode.commercial),
               choicesAllMatching = true);

  parameter Buildings.Electrical.Transmission.MediumVoltageCables.Cable commercialCable_med=
      Functions.selectCable_med(P_nominal, V_nominal)
    "List of Medium Voltage commercial cables"
    annotation(Dialog(tab="Tech. specification", group="Manual mode", enable = mode == Districts.Electrical.Types.CableMode.commercial),
               choicesAllMatching = true);

  final parameter Modelica.SIunits.Temperature T_ref = if voltageLevel==Types.VoltageLevel.Low                      then commercialCable_low.Tref else commercialCable_med.Tref
    "Reference temperature of the line" annotation(Evaluate=True);
  final parameter Modelica.SIunits.Temperature M = Functions.temperatureConstant(                                  voltageLevel, commercialCable_low, commercialCable_med)
    "Temperature constant (R_actual = R*(M + T_heatPort)/(M + T_ref))";
  final parameter Modelica.SIunits.Resistance R=
  Functions.lineResistance(                                  l, voltageLevel, commercialCable_low, commercialCable_med)
    "Resistance of the cable" annotation(Evaluate=True);
  final parameter Modelica.SIunits.Inductance L=
  Functions.lineInductance(                                  l, voltageLevel, commercialCable_low, commercialCable_med)
    "Inductance of the cable due to mutual and self inductance" annotation(Evaluate = True);
  final parameter Modelica.SIunits.Capacitance C=
  Functions.lineCapacitance(                                  l, voltageLevel, commercialCable_low, commercialCable_med)
    "Capacitance of the cable" annotation(Evaluate = True);

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
  assert(L>=0 and R>=0 and C>=0, "The parameters R,L,C must be positive! check cable properties and size");
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
