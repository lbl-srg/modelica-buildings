within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model RecordChillerGroupStructure
  "Validation of chiller group record structure"
  extends Modelica.Icons.Example;

  record BaseChillerPerformanceData
    "Simplified base class for performance data record"
    parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
      "CHW mass flow rate";
    constant Integer nCapFunT "Number of coefficients for capFunT"
      annotation (Dialog(group="Performance curves"));
    parameter Real capFunT[nCapFunT] "Biquadratic coefficients for capFunT"
      annotation (Dialog(group="Performance curves"));
  end BaseChillerPerformanceData;

  record ChillerXXXPerformanceData
    "Simplified performance data record"
    extends BaseChillerPerformanceData(
      nCapFunT=5,
      capFunT=fill(1.9, 5),
      mEva_flow_nominal=1);
  end ChillerXXXPerformanceData;

  record SingleChillerRecord
    "Simplified data record for single chiller"
    parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal=30
      "CHW mass flow rate - Each chiller";
    replaceable parameter BaseChillerPerformanceData per
      constrainedby BaseChillerPerformanceData(
        mEva_flow_nominal=mChiWatChi_flow_nominal);
  end SingleChillerRecord;

  record ChillerGroupRecord
    "Simplified data record for chiller group"
    parameter Integer nChi=3
      "Number of chillers";
    parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=fill(30, nChi)
      "CHW mass flow rate - Each chiller";
    replaceable parameter BaseChillerPerformanceData per[nChi]
      constrainedby BaseChillerPerformanceData(
        mEva_flow_nominal=mChiWatChi_flow_nominal);
    final parameter SingleChillerRecord datChi[nChi](
      final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
      final per=per);
  end ChillerGroupRecord;

  model ChillerGroup
    "Simplified model of chiller group"
    replaceable parameter ChillerGroupRecord rec
      constrainedby ChillerGroupRecord;

    parameter SingleChillerRecord recSin[rec.nChi](
      mChiWatChi_flow_nominal=rec.mChiWatChi_flow_nominal,
      per=rec.per);
  initial equation
    Modelica.Utilities.Streams.print("capFunT[5] = " + String(recSin[2].per.capFunT[5]));
  end ChillerGroup;

  ChillerGroupRecord rec(
    nChi=2,
    mChiWatChi_flow_nominal=fill(99, 2),
    redeclare ChillerXXXPerformanceData per)
    "Record instance for chiller group";

  ChillerGroup mod(rec=rec)
    "Model instance using record binding";

  annotation (Documentation(info="<html>
<p>
This model validates the parameter structure implemented in
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup\">
Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup</a>
and used in the chiller group models within
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.ChillerGroups\">
Buildings.Templates.ChilledWaterPlants.Components.ChillerGroups</a>.
</p>
</html>"));
end RecordChillerGroupStructure;
