// Made with Amplify Shader Editor v1.9.9.9
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tally Light Shader"
{
	Properties
	{
		_MainTex( "MainTex", 2D ) = "white" {}
		_MetallicSmoothness( "MetallicSmoothness", 2D ) = "white" {}
		_Emission( "Emission", 2D ) = "black" {}
		[Normal] _NormalMap( "NormalMap", 2D ) = "white" {}
		[Toggle] _HeartbeatDetected( "Heartbeat Detected", Float ) = 0
		[Toggle] _Error( "Error", Float ) = 0
		[Toggle] _Program( "Program", Float ) = 0
		[Toggle] _Preview( "Preview", Float ) = 0
		[Toggle] _Standby( "Standby", Float ) = 0
		_ErrorColor( "Error Color", Color ) = ( 1, 0, 0.7358327, 0 )
		[Toggle] _ErrorColorFlashes( "Error Color Flashes", Float ) = 1
		_ProgramColor( "Program Color", Color ) = ( 1, 0, 0, 0 )
		[Toggle] _ProgramColorFlashes( "Program Color Flashes", Float ) = 0
		_PreviewColor( "Preview Color", Color ) = ( 0, 1, 0.09638786, 0 )
		[Toggle] _PreviewColorFlashes( "Preview Color Flashes", Float ) = 0
		_StandbyColor( "Standby Color", Color ) = ( 0.006026745, 0, 1, 0 )
		[Toggle] _StandbyColorFlashes( "Standby Color Flashes", Float ) = 0
		_HeartbeatMissing( "Heartbeat Missing", Color ) = ( 1, 0.559062, 0, 0 )
		[Toggle] _HeartbeatMissingFlashes( "Heartbeat Missing Flashes", Float ) = 1
		_ShaderErrorColor( "Shader Error Color", Color ) = ( 0, 0.7945037, 1, 0 )
		[Toggle] _ShaderErrorColorFlashes( "Shader Error Color Flashes", Float ) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#define ASE_VERSION 19909
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _HeartbeatDetected;
		uniform float _HeartbeatMissingFlashes;
		uniform float4 _HeartbeatMissing;
		uniform float _Error;
		uniform float _Program;
		uniform float _Preview;
		uniform float _Standby;
		uniform float _ShaderErrorColorFlashes;
		uniform float4 _ShaderErrorColor;
		uniform float _StandbyColorFlashes;
		uniform float4 _StandbyColor;
		uniform float _PreviewColorFlashes;
		uniform float4 _PreviewColor;
		uniform float _ProgramColorFlashes;
		uniform float4 _ProgramColor;
		uniform float _ErrorColorFlashes;
		uniform float4 _ErrorColor;
		uniform sampler2D _MetallicSmoothness;
		uniform float4 _MetallicSmoothness_ST;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
			float mulTime14 = _Time.y * 5.0;
			float clampResult22 = clamp( sin( mulTime14 ) , 0.0 , 1.0 );
			float Flash17 = clampResult22;
			float4 currentColor67 = (( _HeartbeatDetected )?( (( _Error )?( (( _ErrorColorFlashes )?( ( Flash17 * _ErrorColor ) ):( _ErrorColor )) ):( (( _Program )?( (( _ProgramColorFlashes )?( ( Flash17 * _ProgramColor ) ):( _ProgramColor )) ):( (( _Preview )?( (( _PreviewColorFlashes )?( ( Flash17 * _PreviewColor ) ):( _PreviewColor )) ):( (( _Standby )?( (( _StandbyColorFlashes )?( ( Flash17 * _StandbyColor ) ):( _StandbyColor )) ):( (( _ShaderErrorColorFlashes )?( ( Flash17 * _ShaderErrorColor ) ):( _ShaderErrorColor )) )) )) )) )) ):( (( _HeartbeatMissingFlashes )?( ( Flash17 * _HeartbeatMissing ) ):( _HeartbeatMissing )) ));
			float3 hsvTorgb49 = RGBToHSV( currentColor67.rgb );
			float4 lerpResult50 = lerp( tex2DNode2 , currentColor67 , hsvTorgb49.z);
			float2 uv_MetallicSmoothness = i.uv_texcoord * _MetallicSmoothness_ST.xy + _MetallicSmoothness_ST.zw;
			float4 tex2DNode3 = tex2D( _MetallicSmoothness, uv_MetallicSmoothness );
			float4 lerpResult44 = lerp( tex2DNode2 , lerpResult50 , tex2DNode3.g);
			o.Albedo = lerpResult44.rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 lerpResult43 = lerp( tex2D( _Emission, uv_Emission ) , currentColor67 , tex2DNode3.g);
			o.Emission = lerpResult43.rgb;
			o.Metallic = tex2DNode3.r;
			o.Smoothness = tex2DNode3.a;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Legacy Shaders/Diffuse"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19909
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;14;-1136,608;Inherit;False;1;0;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;-912,608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-1920,1152;Inherit;False;Property;_StandbyColor;Standby Color;15;0;Create;True;0;0;0;False;0;False;0.006026745,0,1,0;0.006026745,0,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;57;-1536,1152;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-1920,896;Inherit;False;Property;_ShaderErrorColor;Shader Error Color;19;0;Create;True;0;0;0;False;0;False;0,0.7945037,1,0;0,0.7945037,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-1536,896;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-752,608;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-1920,1408;Inherit;False;Property;_PreviewColor;Preview Color;13;0;Create;True;0;0;0;False;0;False;0,1,0.09638786,0;0,1,0.09638786,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;-1536,1408;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;56;-1280,1152;Inherit;False;Property;_StandbyColorFlashes;Standby Color Flashes;16;0;Create;True;0;0;0;False;0;False;0;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;66;-1280,896;Inherit;False;Property;_ShaderErrorColorFlashes;Shader Error Color Flashes;20;0;Create;True;0;0;0;False;0;False;1;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-560,608;Inherit;False;Flash;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;29;-1920,1664;Inherit;False;Property;_ProgramColor;Program Color;11;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;-1536,1664;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;-1280,1408;Inherit;False;Property;_PreviewColorFlashes;Preview Color Flashes;14;0;Create;True;0;0;0;False;0;False;0;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;-896,896;Inherit;False;Property;_Standby;Standby;8;0;Create;True;0;0;0;False;0;False;0;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;62;-1536,1920;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-1888,832;Inherit;False;17;Flash;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-1280,1664;Inherit;False;Property;_ProgramColorFlashes;Program Color Flashes;12;0;Create;True;0;0;0;False;0;False;0;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;24;-1920,1920;Inherit;False;Property;_ErrorColor;Error Color;9;0;Create;True;0;0;0;False;0;False;1,0,0.7358327,0;1,0,0.7358327,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-640,896;Inherit;False;Property;_Preview;Preview;7;0;Create;True;0;0;0;False;0;False;0;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;31;-384,896;Inherit;False;Property;_Program;Program;6;0;Create;True;0;0;0;False;0;False;0;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;63;-1280,1920;Inherit;False;Property;_ErrorColorFlashes;Error Color Flashes;10;0;Create;True;0;0;0;False;0;False;1;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;19;-1920,2176;Inherit;False;Property;_HeartbeatMissing;Heartbeat Missing;17;0;Create;True;0;0;0;False;0;False;1,0.559062,0,0;1,0.559062,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;64;-1536,2176;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;26;-128,896;Inherit;False;Property;_Error;Error;5;0;Create;True;0;0;0;False;0;False;0;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;65;-1280,2176;Inherit;False;Property;_HeartbeatMissingFlashes;Heartbeat Missing Flashes;18;0;Create;True;0;0;0;False;0;False;1;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;128,896;Inherit;False;Property;_HeartbeatDetected;Heartbeat Detected;4;0;Create;True;0;0;0;False;0;False;0;True;Create;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1;-1120,-224;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;6;-1120,160;Inherit;True;Property;_Emission;Emission;2;0;Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;-1120,-32;Inherit;True;Property;_MetallicSmoothness;MetallicSmoothness;1;0;Create;True;0;0;0;False;0;False;bfb44e8dcd2318641b7bff46c11f2c2c;bfb44e8dcd2318641b7bff46c11f2c2c;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RGBToHSVNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;768,896;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;67;384,896;Inherit;True;currentColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;-752,-224;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-1120,352;Inherit;True;Property;_NormalMap;NormalMap;3;1;[Normal];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;-752,-32;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-752,160;Inherit;True;Property;_TextureSample2;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;1024,384;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;-752,352;Inherit;True;Property;_TextureSample3;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;44;1408,-128;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;1440,544;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;46;1680,544;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;1872,544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;2048,544;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;1408,256;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;2176,-80;Float;False;True;-1;2;AmplifyShaderEditor.MaterialInspector;0;0;Standard;Tally Light Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;0;False;;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;Legacy Shaders/Diffuse;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;14;0
WireConnection;57;0;40;0
WireConnection;57;1;37;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;22;0;16;0
WireConnection;58;0;40;0
WireConnection;58;1;33;0
WireConnection;56;0;37;0
WireConnection;56;1;57;0
WireConnection;66;0;41;0
WireConnection;66;1;42;0
WireConnection;17;0;22;0
WireConnection;61;0;40;0
WireConnection;61;1;29;0
WireConnection;59;0;33;0
WireConnection;59;1;58;0
WireConnection;39;0;66;0
WireConnection;39;1;56;0
WireConnection;62;0;40;0
WireConnection;62;1;24;0
WireConnection;60;0;29;0
WireConnection;60;1;61;0
WireConnection;35;0;39;0
WireConnection;35;1;59;0
WireConnection;31;0;35;0
WireConnection;31;1;60;0
WireConnection;63;0;24;0
WireConnection;63;1;62;0
WireConnection;64;0;40;0
WireConnection;64;1;19;0
WireConnection;26;0;31;0
WireConnection;26;1;63;0
WireConnection;65;0;19;0
WireConnection;65;1;64;0
WireConnection;11;0;65;0
WireConnection;11;1;26;0
WireConnection;49;0;67;0
WireConnection;67;0;11;0
WireConnection;2;0;1;0
WireConnection;3;0;4;0
WireConnection;5;0;6;0
WireConnection;50;0;2;0
WireConnection;50;1;67;0
WireConnection;50;2;49;3
WireConnection;51;0;8;0
WireConnection;44;0;2;0
WireConnection;44;1;50;0
WireConnection;44;2;3;2
WireConnection;46;0;45;0
WireConnection;47;0;46;0
WireConnection;48;0;47;0
WireConnection;48;1;43;0
WireConnection;43;0;5;0
WireConnection;43;1;67;0
WireConnection;43;2;3;2
WireConnection;0;0;44;0
WireConnection;0;1;51;0
WireConnection;0;2;43;0
WireConnection;0;3;3;1
WireConnection;0;4;3;4
ASEEND*/
//CHKSM=4BF42CB175CCDE82B3F117FB69641C6632091172