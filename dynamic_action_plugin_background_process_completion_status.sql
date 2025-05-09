prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.5'
,p_default_workspace_id=>55020653576245929068
,p_default_application_id=>236965
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DIGITALBIDSUITE'
);
end;
/
 
prompt APPLICATION 236965 - BG Process
--
-- Application Export:
--   Application:     236965
--   Name:            BG Process
--   Date and Time:   13:21 Friday May 9, 2025
--   Exported By:     SRIDHAR2DRAVID@GMAIL.COM
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 40303204934746381444
--   Manifest End
--   Version:         24.2.5
--   Instance ID:     63113759365424
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/background_process_completion_status_inn
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(40303204934746381444)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'BACKGROUND.PROCESS.COMPLETION.STATUS.INN'
,p_display_name=>'ALL_BACKGROUND_PROCESS_COMPLETION_STATUS'
,p_category=>'EXECUTE'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*-------------------------------------',
' * Apex Background Process Completion Status',
' * Version: 1.0 (10-May-2025)',
' * Author:  Sridhar Thayumanavar',
' *-------------------------------------',
' */',
'',
'-- Render Function',
'function render_bg_process(p_dynamic_action in apex_plugin.t_dynamic_action,',
'                            p_plugin         in apex_plugin.t_plugin)',
'return apex_plugin.t_dynamic_action_render_result is',
'    l_result                   apex_plugin.t_dynamic_action_render_result;',
'',
'    -- dynamic action attributes',
'    l_type                   p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_01; ',
'    l_sucess_message         p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_03; ',
'    l_min_file          varchar2(4)  := ''.min'';',
'    l_logging           varchar2(10) := ''false'';',
'',
'begin',
'    -- Debug',
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                              p_dynamic_action => p_dynamic_action);',
'',
'        l_logging  := ''true'';',
'        l_min_file := '''';',
'    end if;',
'    -- Javascript File',
'    apex_javascript.add_library(p_name      => ''BgProcLoad'' || l_min_file,',
'                                p_directory => p_plugin.file_prefix || ''js/'');',
'',
'    l_result.javascript_function := ''BgProcLoad.LoadJS'';',
'    l_result.attribute_01        := apex_plugin.get_ajax_identifier;',
'    -- l_result.attribute_02        := l_logging;',
'  ',
'    return l_result;',
'end render_bg_process;',
'',
'-- Loading BG Process into Collections',
'procedure load_bg_process (pi_interval_id IN NUMBER)',
'is',
'CURSOR BG_CUR ',
'    IS  SELECT BG.EXECUTION_ID, BG.STATUS, BG.STATUS_CODE, BG.PAGE_NAME, BG.PROCESS_NAME',
'          FROM APEX_APPL_PAGE_BG_PROC_STATUS BG ',
'         WHERE BG.APPLICATION_ID = :APP_ID',
'           AND BG.SESSION_ID = :APP_SESSION',
'           AND BG.EXECUTION_ID NOT IN (SELECT N001 ',
'          FROM APEX_COLLECTIONS ',
'         WHERE COLLECTION_NAME = ''BG_COLLECTION''',
'           AND C002 = ''CLOSED'');',
'',
'/* Variable Declaration */    ',
'l_seq_id NUMBER; ',
'l_closed VARCHAR2(10); ',
'',
'BEGIN ',
'',
'IF NOT APEX_COLLECTION.COLLECTION_EXISTS (''BG_COLLECTION'') THEN ',
'APEX_COLLECTION.CREATE_COLLECTION(''BG_COLLECTION'');',
'END IF; ',
'',
'FOR I IN BG_CUR ',
'LOOP',
'',
'BEGIN ',
'SELECT SEQ_ID, C003',
'  INTO l_seq_id,l_closed ',
'  FROM APEX_COLLECTIONS ',
'  WHERE COLLECTION_NAME = ''BG_COLLECTION''',
'    AND N001 = I.EXECUTION_ID; ',
'EXCEPTION ',
'WHEN NO_DATA_FOUND THEN ',
'l_seq_id := 0; ',
'APEX_DEBUG_MESSAGE.LOG_MESSAGE(p_message => ''Fetching Collection. Error ['' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||'']'',',
'                               p_level   => 1 );',
'',
'END; ',
'',
'IF l_seq_id = 0  THEN ',
'  APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''BG_COLLECTION'',',
'        p_n001 => I.execution_id,',
'        p_c001 => I.STATUS,',
'        p_n002 => pi_interval_id, ',
'        p_c002 => I.STATUS_CODE, ',
'        p_c004 => I.PAGE_NAME,',
'        p_c005 => I.PROCESS_NAME',
'        );',
'ELSE ',
'     APEX_COLLECTION.UPDATE_MEMBER(',
'        p_collection_name => ''BG_COLLECTION'',',
'        p_seq             => l_seq_id,',
'        p_n001 => I.execution_id,',
'        p_c001    => I.STATUS,',
'        p_n002 => pi_interval_id,',
'        p_c002 => I.STATUS_CODE,',
'        p_c003 => l_closed,',
'        p_c004 => I.PAGE_NAME,',
'        p_c005 => I.PROCESS_NAME',
'        );',
'END IF;',
'',
'END LOOP; ',
'',
'EXCEPTION  ',
'WHEN OTHERS THEN ',
'APEX_DEBUG_MESSAGE.LOG_MESSAGE(p_message => ''Error ['' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||'']'',',
'                               p_level   => 1 );',
'',
'end;',
'',
'-- Update BG Process Statuses',
'procedure update_bg_process(pi_interval_id IN NUMBER, pi_sucess_msg IN VARCHAR2, pi_disable_process IN VARCHAR2, po_status OUT VARCHAR2, po_unprocess OUT VARCHAR2,po_status_codes OUT VARCHAR2, po_running_process OUT VARCHAR2)',
'is',
'CURSOR BG_COLL_CUR ',
'   IS SELECT SEQ_ID, N001, N002, C001, C002, C003,C004, C005',
'        FROM APEX_COLLECTIONS ',
'       WHERE COLLECTION_NAME = ''BG_COLLECTION''',
'         AND NVL(C003,''XXX'') <> ''CLOSED''; ',
'  ',
'    lv_status CLOB := null; ',
'    ln_unprocessed_bg_processes NUMBER := 0; ',
'    lv_running VARCHAR2(4000) := NULL; ',
'',
'BEGIN  ',
'',
'FOR I IN BG_COLL_CUR ',
'LOOP ',
'',
'ln_unprocessed_bg_processes := ln_unprocessed_bg_processes + 1; ',
'',
'IF I.C002 = ''EXECUTING'' THEN ',
'po_status_codes := I.C002; ',
'lv_running := lv_running||''<b>Page : </b>''||I.C004||''; Process Name : ''||I.C005||'' is running..''; ',
'END IF; ',
'',
'IF I.C002 = ''SUCCESS'' THEN ',
'',
'po_status_codes := I.C002; ',
'',
'IF pi_disable_process = ''Y'' THEN ',
'lv_status := pi_sucess_msg;',
'ELSE',
'lv_status :=  lv_status||''Page : ''||I.C004||''; Process Name : ''||I.C005||''; Status : ''||CASE WHEN pi_sucess_msg is null THEN I.C001 ELSE pi_sucess_msg END ||'' <br><br>''; ',
'END IF; ',
'',
'APEX_COLLECTION.UPDATE_MEMBER(',
'        p_collection_name => ''BG_COLLECTION'',',
'        p_seq             =>  I.SEQ_ID,',
'        p_n001 => I.N001,',
'        p_c001    => I.C001,',
'        p_n002 => pi_interval_id,',
'        p_c002 => I.C002,',
'        p_c003 => ''CLOSED'',',
'        p_c004 => I.C004,',
'        p_c005 => I.C005',
'        );',
'ELSIF I.C002 IN (''FAILED'',''ABORTED'')  THEN ',
'po_status_codes := I.C002; ',
'',
'APEX_COLLECTION.UPDATE_MEMBER(',
'        p_collection_name => ''BG_COLLECTION'',',
'        p_seq             =>  I.SEQ_ID,',
'        p_n001 => I.N001,',
'        p_c001    => I.C001,',
'        p_n002 => pi_interval_id,',
'        p_c002 => I.C002,',
'        p_c003 => ''CLOSED'',',
'        p_c004 => I.C004,',
'        p_c005 => I.C005',
'        );',
'',
'END IF;     ',
'',
'END LOOP; ',
'',
'po_status := lv_status;',
'po_unprocess := ln_unprocessed_bg_processes;',
'po_running_process := lv_running;',
'',
'EXCEPTION ',
'WHEN OTHERS THEN ',
'',
'APEX_DEBUG_MESSAGE.LOG_MESSAGE(p_message => ''Error ['' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||'']'',',
'                               p_level   => 1 );',
' ',
'END; ',
'',
'-- Ajax Function',
'function ajax_bg_proc(p_dynamic_action in apex_plugin.t_dynamic_action,',
'                          p_plugin         in apex_plugin.t_plugin)',
'return apex_plugin.t_dynamic_action_ajax_result is',
'    -- plugin attributes',
'    l_type                   p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_01; --PAGE, URL or DYNAMIC',
'    l_interval_id             apex_application.g_x01%type := apex_application.g_x01;',
'    l_status  CLOB; ',
'    l_unprocess CLOB; ',
'    l_status_cd VARCHAR2(30000); ',
'    l_running_process VARCHAR2(30000); ',
'    l_sucess_message         p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_03; ',
'    l_disble_process_name    p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_04; ',
'    l_process_steps_notification   p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_05; ',
'',
'begin',
'    ',
'    load_bg_process(l_interval_id);',
'    ',
'    update_bg_process(l_interval_id, l_sucess_message, l_disble_process_name, l_status, l_unprocess, l_status_cd, l_running_process);',
'',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    apex_json.write(''message'', ''Success'');',
'    apex_json.write(''sts'', l_status);',
'    apex_json.write(''all_bg_success'', l_unprocess);',
'    apex_json.write(''intevalid'', l_interval_id);',
'    apex_json.write(''status_cd'', l_status_cd);',
'    apex_json.write(''running_process'', l_running_process);',
'    apex_json.write(''process_steps'', l_process_steps_notification);',
'    ',
'    apex_json.close_object;',
'',
'    return null;',
'exception',
'    when others then',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', sqlerrm);',
'        apex_json.write(''sts'', '''');',
'        apex_json.write(''all_bg_success'', '''');',
'        apex_json.write(''intevalid'', '''');',
'        apex_json.write(''status_cd'', '''');',
'        apex_json.write(''running_process'', '''');',
'        apex_json.write(''process_steps'', '''');',
'',
'        apex_json.close_object;',
'',
'        return null;',
'',
'end ajax_bg_proc;'))
,p_api_version=>1
,p_render_function=>'render_bg_process'
,p_ajax_function=>'ajax_bg_proc'
,p_substitute_attributes=>true
,p_version_scn=>15623238487787
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>8
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(40304490249375673604)
,p_plugin_id=>wwv_flow_imp.id(40303204934746381444)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Success Message'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_default_value=>'Executed Successfully!'
,p_max_length=>4000
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(40304729421344406392)
,p_plugin_id=>wwv_flow_imp.id(40303204934746381444)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Disable Page/Process Name'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(40305066185075409794)
,p_plugin_id=>wwv_flow_imp.id(40303204934746381444)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Enable Process Notifications'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '76617220426750726F634C6F6164203D207B0D0A202020200D0A20202020436865636B5374617475733A2066756E6374696F6E287374732C207374617475735F63642C616C6C5F62675F737563636573732C20696E746576616C69642C2072756E6E696E';
wwv_flow_imp.g_varchar2_table(2) := '675F70726F636573732C2070726F636573735F737465707329207B0D0A20200D0A202020636F6E736F6C652E6C6F67282773746174757320272B7374617475735F6364293B0D0A202069662028616C6C5F62675F73756363657373203D3D203029207B0D';
wwv_flow_imp.g_varchar2_table(3) := '0A20202020636C656172496E74657276616C28696E746576616C6964293B20202020200D0A2020207D0D0A2020656C73650D0A2020207B0D0A20202020696620287374617475735F6364203D3D2027535543434553532729207B0D0A2020202061706578';
wwv_flow_imp.g_varchar2_table(4) := '2E6D6573736167652E73686F77506167655375636365737328737473293B0D0A202020207D0D0A20202020656C736520696620287374617475735F6364203D3D2027455845435554494E472729207B0D0A202020202020206966202870726F636573735F';
wwv_flow_imp.g_varchar2_table(5) := '7374657073203D3D2027592729207B0D0A20202020202020617065782E6D6573736167652E73686F7750616765537563636573732872756E6E696E675F70726F63657373293B0D0A2020202020202073657454696D656F75742866756E6374696F6E2829';
wwv_flow_imp.g_varchar2_table(6) := '207B20617065782E6D6573736167652E68696465506167655375636365737328293B20207D2C2031303030293B0D0A202020202020207D0D0A202020207D0D0A20202020656C736520696620287374617475735F6364203D3D202741424F525445442720';
wwv_flow_imp.g_varchar2_table(7) := '7C7C207374617475735F6364203D3D20275445524D494E4154454427207C7C207374617475735F6364203D3D20274641494C45442729207B0D0A2020200D0A20202020766172206572727374733B200D0A20202020696620287374617475735F6364203D';
wwv_flow_imp.g_varchar2_table(8) := '3D202741424F525445442729207B0D0A2020202020202020657272737473203D202750726F636573732041626F72746564273B0D0A202020207D200D0A20202020656C7365207B0D0A2020202020202020657272737473203D202750726F636573732046';
wwv_flow_imp.g_varchar2_table(9) := '61696C6564273B0D0A202020207D0D0A20202020617065782E6D6573736167652E73686F774572726F7273285B0D0A202020207B0D0A2020202020202020747970653A20202020202020226572726F72222C0D0A20202020202020206C6F636174696F6E';
wwv_flow_imp.g_varchar2_table(10) := '3A2020202270616765222C0D0A20202020202020206D6573736167653A202020206572727374732C0D0A2020202020202020756E736166653A202020202066616C73650D0A202020207D0D0A202020205D293B0D0A202020207D0D0A7D0D0A202020207D';
wwv_flow_imp.g_varchar2_table(11) := '2C2020200D0A202020202F2F2066756E6374696F6E207468617420676574732063616C6C65642066726F6D20706C7567696E0D0A202020204C6F61644A533A2066756E6374696F6E2829207B0D0A20202020202020202F2F20706C7567696E2061747472';
wwv_flow_imp.g_varchar2_table(12) := '6962757465730D0A202020202020202076617220646154686973203D20746869733B0D0A0D0A2020202020202020766172206C416A61784964656E74696669657220203D206461546869732E616374696F6E2E61747472696275746530313B0D0A202020';
wwv_flow_imp.g_varchar2_table(13) := '2020202020766172206C547970652020202020202020202020203D206461546869732E616374696F6E2E61747472696275746530333B0D0A0D0A202020202020202076617220696E74657276616C203D20736574496E74657276616C2866756E6374696F';
wwv_flow_imp.g_varchar2_table(14) := '6E28290D0A20202020202020207B200D0A20202020202020202F2F204170657820416A61782043616C6C0D0A2020202020202020617065782E7365727665722E706C7567696E286C416A61784964656E7469666965722C0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(15) := '202020202020202020202020202020207B7830313A696E74657276616C0D0A202020202020202020202020202020202020202020202020202020207D2C0D0A2020202020202020202020202020202020202020202020202020207B202F2F205355434345';
wwv_flow_imp.g_varchar2_table(16) := '53532066756E6374696F6E0D0A2020202020202020202020202020202020202020202020202020202020737563636573733A2066756E6374696F6E28704461746129207B0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(17) := '20206966202870446174612E73756363657373297B0D0A202020202020202020202020202020202020202020202020202020202020202020202020636F6E736F6C652E6C6F6728276C5F73746174757320272B2070446174612E72756E6E696E675F7072';
wwv_flow_imp.g_varchar2_table(18) := '6F63657373293B0D0A202020202020202020202020202020202020202020202020202020202020202020202020426750726F634C6F61642E436865636B5374617475732870446174612E7374732C2070446174612E7374617475735F63642C2070446174';
wwv_flow_imp.g_varchar2_table(19) := '612E616C6C5F62675F737563636573732C2070446174612E696E746576616C69642C2070446174612E72756E6E696E675F70726F636573732C2070446174612E70726F636573735F7374657073293B0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(20) := '202020202020202020202020207D0D0A20202020202020202020202020202020202020202020202020202020207D2C0D0A20202020202020202020202020202020202020202020202020202020202F2F204552524F522066756E6374696F6E0D0A202020';
wwv_flow_imp.g_varchar2_table(21) := '20202020202020202020202020202020202020202020202020206572726F723A2066756E6374696F6E287868722C20704D65737361676529207B0D0A20202020202020202020202020202020202020202020202020202020202020202F2F206C6F672065';
wwv_flow_imp.g_varchar2_table(22) := '72726F7220696E20636F6E736F6C650D0A2020202020202020202020202020202020202020202020202020202020202020617065782E64656275672E747261636528276F70656E4469616C6F673A20617065782E7365727665722E706C7567696E204552';
wwv_flow_imp.g_varchar2_table(23) := '524F523A272C20704D657373616765293B0D0A20202020202020202020202020202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020202020202020207D293B0D0A20202020202020207D2C203230303029';
wwv_flow_imp.g_varchar2_table(24) := '3B20090909090909090D0A202020207D0D0A7D3B';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(40303891312975662562)
,p_plugin_id=>wwv_flow_imp.id(40303204934746381444)
,p_file_name=>'js/BgProcLoad.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '76617220426750726F634C6F61643D7B436865636B5374617475733A66756E6374696F6E28652C732C612C742C6F2C63297B696628636F6E736F6C652E6C6F67282273746174757320222B73292C303D3D6129636C656172496E74657276616C2874293B';
wwv_flow_imp.g_varchar2_table(2) := '656C7365206966282253554343455353223D3D7329617065782E6D6573736167652E73686F7750616765537563636573732865293B656C73652069662822455845435554494E47223D3D73292259223D3D63262628617065782E6D6573736167652E7368';
wwv_flow_imp.g_varchar2_table(3) := '6F775061676553756363657373286F292C73657454696D656F7574282866756E6374696F6E28297B617065782E6D6573736167652E68696465506167655375636365737328297D292C31653329293B656C7365206966282241424F52544544223D3D737C';
wwv_flow_imp.g_varchar2_table(4) := '7C225445524D494E41544544223D3D737C7C224641494C4544223D3D73297B76617220723B723D2241424F52544544223D3D733F2250726F636573732041626F72746564223A2250726F63657373204661696C6564222C617065782E6D6573736167652E';
wwv_flow_imp.g_varchar2_table(5) := '73686F774572726F7273285B7B747970653A226572726F72222C6C6F636174696F6E3A2270616765222C6D6573736167653A722C756E736166653A21317D5D297D7D2C4C6F61644A533A66756E6374696F6E28297B76617220653D746869732E61637469';
wwv_flow_imp.g_varchar2_table(6) := '6F6E2E61747472696275746530312C733D28746869732E616374696F6E2E61747472696275746530332C736574496E74657276616C282866756E6374696F6E28297B617065782E7365727665722E706C7567696E28652C7B7830313A737D2C7B73756363';
wwv_flow_imp.g_varchar2_table(7) := '6573733A66756E6374696F6E2865297B652E73756363657373262628636F6E736F6C652E6C6F6728226C5F73746174757320222B652E72756E6E696E675F70726F63657373292C426750726F634C6F61642E436865636B53746174757328652E7374732C';
wwv_flow_imp.g_varchar2_table(8) := '652E7374617475735F63642C652E616C6C5F62675F737563636573732C652E696E746576616C69642C652E72756E6E696E675F70726F636573732C652E70726F636573735F737465707329297D2C6572726F723A66756E6374696F6E28652C73297B6170';
wwv_flow_imp.g_varchar2_table(9) := '65782E64656275672E747261636528226F70656E4469616C6F673A20617065782E7365727665722E706C7567696E204552524F523A222C73297D7D297D292C32653329297D7D3B';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(40429999246163301985)
,p_plugin_id=>wwv_flow_imp.id(40303204934746381444)
,p_file_name=>'js/BgProcLoad.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
