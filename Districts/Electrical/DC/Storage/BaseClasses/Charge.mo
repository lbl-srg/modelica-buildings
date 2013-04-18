within Districts.Electrical.DC.Storage.BaseClasses;
model Charge "Model to compute the battery charge"
  extends Modelica.Blocks.Interfaces.BlockIcon;
 parameter Real etaCha(min=0, max=1, unit="1") = 0.9
    "Efficiency during charging";
 parameter Real etaDis(min=0, max=1, unit="1") = 0.9
    "Efficiency during discharging";
 parameter Modelica.SIunits.Energy EMax(displayUnit="kWh")
    "Maximum available charge";
 //Modelica.SIunits.Energy E(min=0, displayUnit="kWh") "Actual charge";
  Modelica.SIunits.Power PAct "Actual power";
  parameter Real SOC_start(min=0, max=1, unit="1")=0 "Initial charge";
  Modelica.Blocks.Interfaces.RealInput P(final quantity="Power",
                                         final unit="W") annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{
            -100,20}})));
  Modelica.Blocks.Interfaces.RealOutput SOC(min=0, max=1) "State of charge" annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,
            10}})));
protected
  Boolean underCharged "Flag, true if battery is undercharged";
  Boolean overCharged "Flag, true if battery is overcharged";

initial equation
  pre(underCharged) = SOC_start < 0;
  pre(overCharged)  = SOC_start > 1;

  SOC = SOC_start;
equation
  // Charge balance of battery
  PAct = if P > 0 then etaCha*P else (2-etaDis)*P;
  der(SOC)=PAct/EMax;

  // Equations to warn if state of charge exceeds 0 and 1
  underCharged = SOC < 0;
  overCharged = SOC > 1;
  when change(underCharged) or change(overCharged) then
    assert(SOC >= 0, "Warning: Battery is below minimum charge.",
    level=AssertionLevel.warning);
    assert(SOC <= 1, "Warning: Battery is above maximum charge.",
    level=AssertionLevel.warning);
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics));
end Charge;
