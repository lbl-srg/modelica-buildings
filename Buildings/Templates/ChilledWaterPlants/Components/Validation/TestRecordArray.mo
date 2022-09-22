within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model TestRecordArray
  extends Modelica.Icons.Example;

  record BaseChillerPerformanceData
    parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
      "CHW mass flow rate";
    constant Integer nCapFunT "Number of coefficients for capFunT"
      annotation (Dialog(group="Performance curves"));
    parameter Real capFunT[nCapFunT] "Biquadratic coefficients for capFunT"
      annotation (Dialog(group="Performance curves"));
  end BaseChillerPerformanceData;

  record ChillerXXXPerformanceData
    extends BaseChillerPerformanceData(
      nCapFunT=5,
      capFunT=fill(1.9, 5),
      mEva_flow_nominal=1);
  end ChillerXXXPerformanceData;

  record SingleChillerRecord
    parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal=30
      "CHW mass flow rate for each chiller";
    replaceable parameter BaseChillerPerformanceData per
      constrainedby BaseChillerPerformanceData(
        mEva_flow_nominal=mChiWatChi_flow_nominal);
  end SingleChillerRecord;

  record ChillerGroupRecord
    parameter Integer nChi=3
      "Number of chillers";
    parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=fill(30, nChi)
      "CHW mass flow rate for each chiller";
    replaceable parameter BaseChillerPerformanceData per[nChi]
      constrainedby BaseChillerPerformanceData(
        mEva_flow_nominal=mChiWatChi_flow_nominal);
    final parameter SingleChillerRecord datChi[nChi](
      final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
      final per=per);
  end ChillerGroupRecord;

  model M
    replaceable parameter ChillerGroupRecord rec
      constrainedby ChillerGroupRecord;
  end M;

  ChillerGroupRecord rec(
    nChi=2,
    mChiWatChi_flow_nominal=fill(99, 2),
    redeclare each ChillerXXXPerformanceData per);

  M mod(rec=rec);

end TestRecordArray;
