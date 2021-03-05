within Buildings.Templates.AHUs.Coils.Data;
record WaterBased
  extends Interfaces.Data.Coil;

  inner parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal(min=0)=
    dat.getReal(varName=id + "." + funStr + " coil.Liquid mass flow rate")
    "Liquid mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  inner parameter Modelica.SIunits.PressureDifference dpWat_nominal(
    displayUnit="Pa")=
    dat.getReal(varName=id + "." + funStr + " coil.Liquid pressure drop")
    "Liquid pressure drop"
    annotation(Dialog(group = "Nominal condition"));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
If datHex is declared as
</p>
  replaceable parameter HeatExchangers.Data.EffectivenessNTU datHex
    constrainedby HeatExchangers.Data.None
<p>
Dymola gives the following error
</p>
        Translation of Buildings.Templates.AHUs.Validation.CoolingCoilDiscretized:

        Inner must be subtype of outer
But missing component Q_flow_nominal.
Error found inside component datHex.
Component outer Buildings.Templates.AHUs.Coils.Data.WaterBased datCoi:
File: /home/agautier/gitrepo/modelica-buildings/Buildings/Experimental/Templates/AHUs/Coils/HeatExchangers/Discretized.mo, line 9
Compared to inner Buildings.Templates.AHUs.Validation.CoolingCoilDiscretized.RecordCoiCoo datCoi:
File: /home/agautier/gitrepo/modelica-buildings/Buildings/Experimental/Templates/AHUs/Main/VAVSingleDuct.mo, line 151
<p>
No issue (and no warning) with OCT.
Cannot reproduce with minimum example.
</p>
</html>"));
end WaterBased;
