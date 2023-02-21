within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block ModeHeatRecoveryChiller
  "Block that computes the cascading cooling and direct HR switchover signals"

  parameter Integer nChiHea
    "Number of HRC"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nCasCoo
    "Number of units required to be operating in cascading cooling mode"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nHeaCoo
    "Number of HRC required to be operating in direct HR mode"
    annotation (
      Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo[nChiHea]
    "Command signal for cascading cooling mode"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaCoo[nChiHea]
    "Command signal for direct HR mode"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
protected
  Integer lasTruIdx;
  Integer counter;
algorithm
  y1Coo := fill(false, nChiHea);
  y1HeaCoo := fill(false, nChiHea);
  lasTruIdx := 0;
  counter := 1;
  for i in 1:nChiHea loop
    if counter > nHeaCoo then
      break;
    end if;
    if i > nCasCoo then
      y1HeaCoo[nChiHea - i + 1] := true;
      counter := counter + 1;
    end if;
  end for;
  for i in 1:nChiHea loop
    if y1HeaCoo[i] then
      lasTruIdx := i;
    end if;
  end for;
  counter := 1;
  for i in 1:nChiHea loop
    if counter > nCasCoo then
      break;
    end if;
    y1Coo[nChiHea - i + 1] := true;
    counter := counter + 1;
  end for;

  annotation (
  defaultComponentName="idxHeaCoo",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block computes the command signals to the HRCs to initiate
the switchover into either cascading cooling mode (with the evaporator
indexed to the CHW loop and the condenser indexed to the CW loop)
or direct heat recovery mode (with the evaporator
indexed to the CHW loop and the condenser indexed to the HW loop).
Switching a HRC to cascading cooling mode is done starting from the unit nearest
to the CW interconnection, that is the unit with the highest index.
Switching a HRC to direct heat recovery mode is done starting from the unit nearest
to the CW interconnection and that is not operating in cascading cooling,
that is the unit with the highest index below the lowest index of HRCs operating
in cascading cooling mode.
</p>
</html>"));
end ModeHeatRecoveryChiller;
