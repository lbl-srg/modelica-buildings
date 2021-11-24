within Buildings.Templates.BaseClasses;
package ExternDataLocal
  "Classes derived from ExternData library for evaluation at compile time"

  record JSONFile "Read data values from JSON file"
    parameter String fileName="" "File where external data is stored"
      annotation(Dialog(
        loadSelector(filter="JSON files (*.json)",
        caption="Open file")));
    parameter Boolean verboseRead=true "= true, if info message that file is loading is to be printed";
    final parameter ExternData.Types.ExternJSONFile json=
        ExternData.Types.ExternJSONFile(fileName, verboseRead)
      "External JSON file object";
    extends ExternData.Interfaces.JSON.Base(
      redeclare final function getReal = Functions.JSON.getReal (
            json=json) "Get scalar Real value from JSON file" annotation (
          Documentation(info="<html></html>")),
      redeclare final function getRealArray1D =
          Functions.JSON.getRealArray1D (json=json)
        "Get 1D array Real value from JSON file" annotation (Documentation(info=
             "<html></html>")),
      redeclare final function getRealArray2D =
          Functions.JSON.getRealArray2D (json=json)
        "Get 2D array Real value from JSON file" annotation (Documentation(info=
             "<html></html>")),
      redeclare final function getInteger =
          Functions.JSON.getInteger (json=json)
        "Get scalar Integer value from JSON file" annotation (Documentation(
            info="<html></html>")),
      redeclare final function getIntegerArray1D =
          Functions.JSON.getIntegerArray1D (json=json)
        "Get 1D array Integer value from JSON file" annotation (Documentation(
            info="<html></html>")),
      redeclare final function getIntegerArray2D =
          Functions.JSON.getIntegerArray2D (json=json)
        "Get 2D array Integer value from JSON file" annotation (Documentation(
            info="<html></html>")),
      redeclare final function getBoolean =
          Functions.JSON.getBoolean (json=json)
        "Get scalar Boolean value from JSON file" annotation (Documentation(
            info="<html></html>")),
      redeclare final function getBooleanArray1D =
          Functions.JSON.getBooleanArray1D (json=json)
        "Get 1D array Boolean value from JSON file" annotation (Documentation(
            info="<html></html>")),
      redeclare final function getBooleanArray2D =
          Functions.JSON.getBooleanArray2D (json=json)
        "Get 2D array Boolean value from JSON file" annotation (Documentation(
            info="<html></html>")),
      redeclare final function getString = Functions.JSON.getString (
           json=json) "Get scalar String value from JSON file" annotation (
          Documentation(info="<html></html>")),
      redeclare final function getStringArray1D =
          Functions.JSON.getStringArray1D (json=json)
        "Get 1D array String value from JSON file" annotation (Documentation(
            info="<html></html>")),
      redeclare final function getStringArray2D =
          Functions.JSON.getStringArray2D (json=json)
        "Get 2D array String value from JSON file" annotation (Documentation(
            info="<html></html>")),
      redeclare final function getArraySize1D =
          Functions.JSON.getArraySize1D (json=json)
        "Get the size of a 1D array in a JSON file" annotation (Documentation(
            info="<html></html>")),
      redeclare final function getArraySize2D =
          Functions.JSON.getArraySize2D (json=json)
        "Get the size of a 2D array in a JSON file" annotation (Documentation(
            info="<html></html>")),
      redeclare final function getArrayRows2D =
          Functions.JSON.getArrayRows2D (json=json)
        "Get first dimension of 2D array in JSON file" annotation (
          Documentation(info="<html></html>")),
      redeclare final function getArrayColumns2D =
          Functions.JSON.getArrayColumns2D (json=json)
        "Get second dimension of 2D array in JSON file" annotation (
          Documentation(info="<html></html>")));
    annotation (
      Documentation(info="<html><p>Record that wraps the external object <a href=\"modelica://ExternData.Types.ExternJSONFile\">ExternJSONFile</a> and the <a href=\"modelica://ExternData.Functions.JSON\">JSON</a> read functions for data access of <a href=\"https://en.wikipedia.org/wiki/JSON\">JSON</a> files.</p><p>See <a href=\"modelica://ExternData.Examples.JSONTest\">Examples.JSONTest</a> for an example.</p></html>"),
      defaultComponentName="jsonfile",
      defaultComponentPrefixes="inner parameter",
      missingInnerMessage="No \"jsonfile\" component is defined, please drag ExternData.JSONFile to the model top level",
      Icon(graphics={
        Text(lineColor={0,0,255},extent={{-85,-10},{85,-55}},textString="{\"json\"}"),
        Text(lineColor={0,0,255},extent={{-150,150},{150,110}},textString="%name")}));
  end JSONFile;

  package Functions "Functions"
    extends Modelica.Icons.FunctionsPackage;

    package JSON "JSON file functions"
      extends Modelica.Icons.FunctionsPackage;

      function getReal "Get scalar Real value from JSON file"
        extends ExternData.Functions.JSON.getReal;
      annotation(__Dymola_translate=true);
      end getReal;

      function getRealArray1D "Get 1D Real values from JSON file"
        extends ExternData.Functions.JSON.getRealArray1D;
        annotation(__Dymola_translate=true);
      end getRealArray1D;

      function getRealArray2D "Get 2D Real values from JSON file"
        extends ExternData.Functions.JSON.getRealArray2D;
        annotation(__Dymola_translate=true);
      end getRealArray2D;

      function getInteger "Get scalar Integer value from JSON file"
        extends ExternData.Functions.JSON.getInteger;
        annotation(__Dymola_translate=true);
      end getInteger;

      function getIntegerArray1D "Get 1D Integer values from JSON file"
        extends ExternData.Functions.JSON.getIntegerArray1D;
        annotation(__Dymola_translate=true);
      end getIntegerArray1D;

      function getIntegerArray2D "Get 2D Integer values from JSON file"
        extends ExternData.Functions.JSON.getIntegerArray2D;
        annotation(__Dymola_translate=true);
      end getIntegerArray2D;

      function getBoolean "Get scalar Boolean value from JSON file"
        extends ExternData.Functions.JSON.getBoolean;
        annotation(__Dymola_translate=true);
      end getBoolean;

      function getBooleanArray1D "Get 1D Boolean values from JSON file"
        extends ExternData.Functions.JSON.getBooleanArray1D;
        annotation(__Dymola_translate=true);
      end getBooleanArray1D;

      function getBooleanArray2D "Get 2D Boolean values from JSON file"
        extends ExternData.Functions.JSON.getBooleanArray2D;
        annotation(__Dymola_translate=true);
      end getBooleanArray2D;

      function getString "Get scalar String value from JSON file"
        extends ExternData.Functions.JSON.getString;
        annotation(__Dymola_translate=true);
      end getString;

      function getStringArray1D "Get 1D String values from JSON file"
        extends ExternData.Functions.JSON.getStringArray1D;
        annotation(__Dymola_translate=true);
      end getStringArray1D;

      function getStringArray2D "Get 2D String values from JSON file"
        extends ExternData.Functions.JSON.getStringArray2D;
        annotation(__Dymola_translate=true);
      end getStringArray2D;

      function getArraySize1D "Get length of 1D array in JSON file"
        extends ExternData.Functions.JSON.getArraySize1D;
        annotation(__Dymola_translate=true);
      end getArraySize1D;

      function getArraySize2D "Get dimensions of 2D array in JSON file"
        extends ExternData.Functions.JSON.getArraySize2D;
        annotation(__Dymola_translate=true);
      end getArraySize2D;

      function getArrayRows2D "Get first dimension of 2D array in JSON file"
        extends ExternData.Functions.JSON.getArrayRows2D;
        annotation(__Dymola_translate=true);
      end getArrayRows2D;

      function getArrayColumns2D "Get second dimension of 2D array in JSON file"
        extends ExternData.Functions.JSON.getArrayColumns2D;
        annotation(__Dymola_translate=true);
      end getArrayColumns2D;
    end JSON;

  end Functions;
end ExternDataLocal;
