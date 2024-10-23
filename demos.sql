--
-- PostgreSQL database dump
--

-- Dumped from database version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: button_status(text, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.button_status(_projectname text, _button text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$Declare
	projectref refcursor default 'refcursor'; 
begin
	OPEN projectref for
	SELECT  button
	FROM public.projectlisting where project_name = _projectname;
	return projectref;
End;$$;


ALTER FUNCTION public.button_status(_projectname text, _button text) OWNER TO postgreuser;

--
-- Name: code_validation(text, character varying); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.code_validation(_username text, _code character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$declare
code character varying;
begin
SELECT forgot_password_code from userdetails where username = _username into code;
if code = _code then
    return 'Code Validated Successfully.';
else 
    return 'Invalid code.';
end if;
end;$$;


ALTER FUNCTION public.code_validation(_username text, _code character varying) OWNER TO postgreuser;

--
-- Name: count_server(); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.count_server() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$Declare
	projectref refcursor default 'refcursor'; 
begin
	OPEN projectref for
    SELECT COUNT(*)
	FROM public.projectlisting where button = 'stop';
	return projectref;
End;$$;


ALTER FUNCTION public.count_server() OWNER TO postgreuser;

--
-- Name: created_at(text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.created_at(_username text) RETURNS text
    LANGUAGE plpgsql
    AS $$begin
UPDATE public.userdetails
	SET created_at = now()
	WHERE username = _username;
    return 'Successfully Created';
end;$$;


ALTER FUNCTION public.created_at(_username text) OWNER TO postgreuser;

--
-- Name: demos_list(); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.demos_list() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
Declare
	projectref refcursor default 'refcursor'; 
begin
	OPEN projectref for
	SELECT dns, project_name, project_description, tech_stack, versions, ip_address, git_url, status, button, id
	FROM public.projectlisting order by id;
	return projectref;
End;
$$;


ALTER FUNCTION public.demos_list() OWNER TO postgreuser;

--
-- Name: forgot_password(text, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.forgot_password(_username text, _password text) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
name character varying;
pass character varying;
begin
SELECT username from userdetails where username = _username into name;
SELECT password from userdetails where username = _username into pass;
    if name = _username AND pass != _password then
        UPDATE public.userdetails
            SET password = _password
            WHERE username = _username;
            return 'Successfully Updated Password';
    else
        return 'You have already used this Password, Please use new Password';
    end if;
end;
$$;


ALTER FUNCTION public.forgot_password(_username text, _password text) OWNER TO postgreuser;

--
-- Name: get_email(text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.get_email(_username text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$Declare
	projectref refcursor default 'refcursor'; 
begin
	OPEN projectref for
    SELECT email from public.userdetails
    where username = _username;
    return projectref;
    
end;$$;


ALTER FUNCTION public.get_email(_username text) OWNER TO postgreuser;

--
-- Name: get_phonenumber(bigint); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.get_phonenumber(_phone_num bigint) RETURNS character varying
    LANGUAGE plpgsql
    AS $$declare 
number bigint;
begin
SELECT phone_num from userdetails where phone_num = _phone_num into number;
    if number = _phone_num then
        return number;
    else
        return 'Phone number does not exist';
    end if;
end;$$;


ALTER FUNCTION public.get_phonenumber(_phone_num bigint) OWNER TO postgreuser;

--
-- Name: get_user(text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.get_user(_username text) RETURNS text
    LANGUAGE plpgsql
    AS $$
Declare
	projectref refcursor default 'refcursor'; 
begin
	OPEN projectref for
	SELECT username
	FROM public.userdetails where username=_username;
	return projectref;
End;
$$;


ALTER FUNCTION public.get_user(_username text) OWNER TO postgreuser;

--
-- Name: insert_project_det(text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.insert_project_det(_dns text, _projectname text, _projectdescription text, _techstack text, _versions text, _ipaddress text, _giturl text, _status text, _button text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
INSERT INTO public.projectlisting(
	dns, project_name, project_description, tech_stack, versions, ip_address, git_url, status, button)
	VALUES (_dns, _projectname, _projectdescription, _techstack, _versions, _ipaddress, _giturl, _status, _button);
	return 'Successfully Created';
end;
$$;


ALTER FUNCTION public.insert_project_det(_dns text, _projectname text, _projectdescription text, _techstack text, _versions text, _ipaddress text, _giturl text, _status text, _button text) OWNER TO postgreuser;

--
-- Name: insert_users_details(text, text, text, boolean, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.insert_users_details(_username text, _emial text, _password text, _is_active boolean, _role text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
INSERT INTO public.userdetails(
	username, email, password, is_active, role)
	VALUES (_username, _emial, _password, _is_active, _role);
    return 'Successfully Created User';
end;
$$;


ALTER FUNCTION public.insert_users_details(_username text, _emial text, _password text, _is_active boolean, _role text) OWNER TO postgreuser;

--
-- Name: insertdata(text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.insertdata(_dns text, _project_name text, _project_description text, _tech_stack text, _versions text, _ip_address text, _git_url text, _status text, _button text) RETURNS text
    LANGUAGE plpgsql
    AS $$Declare
dns text;
projectname text;
project_description text;
tech_stack text;
versions text;
ip_address text;
git_url text;
status text;
button text;
Begin
INSERT INTO public.projectlisting(
	dns, project_name, project_description, tech_stack, versions, ip_address, git_url, status, button)
	VALUES (_dns,_project_name,_project_description,_tech_stack,_versions,_ip_address,_git_url,_status,_button);
    return projectname;
End;$$;


ALTER FUNCTION public.insertdata(_dns text, _project_name text, _project_description text, _tech_stack text, _versions text, _ip_address text, _git_url text, _status text, _button text) OWNER TO postgreuser;

--
-- Name: login(text, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.login(_username text, _password text) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
    cnt integer;
    msg text;
result_record text;
begin
select count(*) into cnt from userdetails where username = _username and password = _password;
if cnt>0
then
return 'successfully validated';
else
return 'Login Failure';
end if;
return result_record;
end;
$$;


ALTER FUNCTION public.login(_username text, _password text) OWNER TO postgreuser;

--
-- Name: login_validation(text, integer); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.login_validation(_username text, _code integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare
code integer;
begin
SELECT login_otp from userdetails where username = _username into code;
if code = _code then
    return 'OTP Validated Successfully.';
else 
    return 'Invalid OTP.';
end if;
end;
$$;


ALTER FUNCTION public.login_validation(_username text, _code integer) OWNER TO postgreuser;

--
-- Name: new_forgot_password(text, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.new_forgot_password(_username text, _password text) RETURNS text
    LANGUAGE plpgsql
    AS $$declare
name character varying;
pass character varying;
oldpass character varying;
begin
SELECT username from userdetails where username = _username into name;
SELECT password from userdetails where username = _username into pass;
SELECT old_password from userdetails where username = _username into  oldpass;
    if name = _username AND pass != _password then
        UPDATE public.userdetails
            SET old_password = pass
            WHERE username = _username;        
            
        UPDATE public.userdetails
            SET password = _password
            WHERE username = _username;
        
        
            return 'Successfully Updated Password';
    else
        return 'You have already used this Password, Please use new Password';
    end if;
end;$$;


ALTER FUNCTION public.new_forgot_password(_username text, _password text) OWNER TO postgreuser;

--
-- Name: project_status(text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.project_status(_projectname text) RETURNS text
    LANGUAGE plpgsql
    AS $$
Declare
	ref1 refcursor default 'refcursor'; 
begin
	OPEN ref1 for
	SELECT dns, project_name, project_description, tech_stack, versions, ip_address, git_url, status, button
	FROM public.project_list where project_name='Apollo POS';
	return ref1;
End;

$$;


ALTER FUNCTION public.project_status(_projectname text) OWNER TO postgreuser;

--
-- Name: projectname(text, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.projectname(_projectname text, _status text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

Declare
	ref1 refcursor default 'refcursor'; 
begin
	OPEN ref1 for
	select pn.project_name,pn.button 
	from public.project_list pn
	where project_name=_projectname and button=_status;
	return ref1;
End;
$$;


ALTER FUNCTION public.projectname(_projectname text, _status text) OWNER TO postgreuser;

--
-- Name: start(text, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.start(_projectname text, _button text) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
buttonstats character varying;
begin
    select button from public.projectlisting where project_name = _projectname into buttonstats;
    if buttonstats='stop' then 
        UPDATE public.projectlisting
        SET button=_button
        WHERE project_name = _projectname and button = 'stop';
        return 'Status updated to start';
    else
        return 'Server is already started';
    end if;
end;
$$;


ALTER FUNCTION public.start(_projectname text, _button text) OWNER TO postgreuser;

--
-- Name: stop(text, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.stop(_projectname text, _button text) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
buttonstats character varying;
begin
    select button from public.projectlisting where project_name = _projectname into buttonstats;
    if buttonstats='start' then 
        UPDATE public.projectlisting
        SET button=_button
        WHERE project_name = _projectname and button = 'start';
        return 'Status updated to stop';
    else
        return 'Server is already stopped';
    end if;
end;
$$;


ALTER FUNCTION public.stop(_projectname text, _button text) OWNER TO postgreuser;

--
-- Name: update_code(text, character varying); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.update_code(_username text, _code character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$begin
 UPDATE public.userdetails SET forgot_password_code=_code WHERE username = _username;
end;$$;


ALTER FUNCTION public.update_code(_username text, _code character varying) OWNER TO postgreuser;

--
-- Name: update_dns(integer, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.update_dns(_id integer, _dns text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
UPDATE public.projectlisting
	SET dns = _dns
	WHERE id = _id;
    return 'Successfully Updated';
end;
$$;


ALTER FUNCTION public.update_dns(_id integer, _dns text) OWNER TO postgreuser;

--
-- Name: update_git_url(integer, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.update_git_url(_id integer, _git_url text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
UPDATE public.projectlisting
	SET git_url = _git_url
	WHERE id = _id;
    return 'Successfully Updated';
end;
$$;


ALTER FUNCTION public.update_git_url(_id integer, _git_url text) OWNER TO postgreuser;

--
-- Name: update_ip_address(integer, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.update_ip_address(_id integer, _ip_address text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
UPDATE public.projectlisting
	SET ip_address = _ip_address
	WHERE id = _id;
    return 'Successfully Updated';
end;
$$;


ALTER FUNCTION public.update_ip_address(_id integer, _ip_address text) OWNER TO postgreuser;

--
-- Name: update_project_name(integer, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.update_project_name(_id integer, _projectname text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
UPDATE public.projectlisting
	SET project_name = _projectname
	WHERE id = _id;
    return 'Successfully Updated';
end;
$$;


ALTER FUNCTION public.update_project_name(_id integer, _projectname text) OWNER TO postgreuser;

--
-- Name: update_projectdesc(integer, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.update_projectdesc(_id integer, _project_description text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
UPDATE public.projectlisting
	SET project_description = _project_description
	WHERE id = _id;
    return 'Successfully Updated';
end;
$$;


ALTER FUNCTION public.update_projectdesc(_id integer, _project_description text) OWNER TO postgreuser;

--
-- Name: update_status(integer, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.update_status(_id integer, _status text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
UPDATE public.projectlisting
	SET status = _status
	WHERE id = _id;
    return 'Successfully Updated';
end;
$$;


ALTER FUNCTION public.update_status(_id integer, _status text) OWNER TO postgreuser;

--
-- Name: update_tech_stack(integer, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.update_tech_stack(_id integer, _tech_stack text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
UPDATE public.projectlisting
	SET tech_stack = _tech_stack
	WHERE id = _id;
    return 'Successfully Updated';
end;
$$;


ALTER FUNCTION public.update_tech_stack(_id integer, _tech_stack text) OWNER TO postgreuser;

--
-- Name: update_versions(integer, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.update_versions(_id integer, _versions text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
UPDATE public.projectlisting
	SET versions = _versions
	WHERE id = _id;
    return 'Successfully Updated';
end;
$$;


ALTER FUNCTION public.update_versions(_id integer, _versions text) OWNER TO postgreuser;

--
-- Name: updated_at(text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.updated_at(_username text) RETURNS text
    LANGUAGE plpgsql
    AS $$begin
UPDATE public.userdetails
	SET updated_at = now()
	WHERE username = _username;
    return 'Successfully Updated';
end;$$;


ALTER FUNCTION public.updated_at(_username text) OWNER TO postgreuser;

--
-- Name: updatetablestart(text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.updatetablestart(_projectname text) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	UPDATE public.project_list
	SET button='start'
	WHERE project_name=_projectname;
--  	commit;
End;
$$;


ALTER FUNCTION public.updatetablestart(_projectname text) OWNER TO postgreuser;

--
-- Name: updatetablestop(text, text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.updatetablestop(_projectname text, _button text) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	UPDATE public.project_list
	SET button='start'
	WHERE project_name=_projectname AND button= _button;
--  	commit;
End;
$$;


ALTER FUNCTION public.updatetablestop(_projectname text, _button text) OWNER TO postgreuser;

--
-- Name: updatetablestop2nd(text); Type: FUNCTION; Schema: public; Owner: postgreuser
--

CREATE FUNCTION public.updatetablestop2nd(_projectname text) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	UPDATE public.project_list
	SET button='stop'
	WHERE project_name=_projectname;
--  	commit;
End;
$$;


ALTER FUNCTION public.updatetablestop2nd(_projectname text) OWNER TO postgreuser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_emailaddress; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.account_emailaddress (
    id integer NOT NULL,
    email character varying(254) NOT NULL,
    verified boolean NOT NULL,
    "primary" boolean NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.account_emailaddress OWNER TO postgreuser;

--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.account_emailaddress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_emailaddress_id_seq OWNER TO postgreuser;

--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.account_emailaddress_id_seq OWNED BY public.account_emailaddress.id;


--
-- Name: account_emailconfirmation; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.account_emailconfirmation (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    sent timestamp with time zone,
    key character varying(64) NOT NULL,
    email_address_id integer NOT NULL
);


ALTER TABLE public.account_emailconfirmation OWNER TO postgreuser;

--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.account_emailconfirmation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_emailconfirmation_id_seq OWNER TO postgreuser;

--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.account_emailconfirmation_id_seq OWNED BY public.account_emailconfirmation.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgreuser;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgreuser;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgreuser;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgreuser;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgreuser;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgreuser;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgreuser;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgreuser;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO postgreuser;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO postgreuser;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgreuser;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO postgreuser;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.authtoken_token OWNER TO postgreuser;

--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgreuser;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgreuser;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgreuser;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgreuser;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgreuser;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgreuser;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgreuser;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO postgreuser;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.django_site_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO postgreuser;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.django_site_id_seq OWNED BY public.django_site.id;


--
-- Name: projectlisting; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.projectlisting (
    dns text,
    project_name text,
    project_description text,
    tech_stack text,
    versions text,
    ip_address text,
    git_url text,
    status text,
    button text,
    id integer NOT NULL
);


ALTER TABLE public.projectlisting OWNER TO postgreuser;

--
-- Name: projectlisting1; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.projectlisting1 (
    dns text,
    project_name text,
    project_description text,
    tech_stack text,
    versions text,
    ip_address text,
    git_url text,
    status text,
    button text
);


ALTER TABLE public.projectlisting1 OWNER TO postgreuser;

--
-- Name: projectlisting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgreuser
--

CREATE SEQUENCE public.projectlisting_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projectlisting_id_seq OWNER TO postgreuser;

--
-- Name: projectlisting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgreuser
--

ALTER SEQUENCE public.projectlisting_id_seq OWNED BY public.projectlisting.id;


--
-- Name: userdetails; Type: TABLE; Schema: public; Owner: postgreuser
--

CREATE TABLE public.userdetails (
    username text,
    email text NOT NULL,
    password text,
    is_active boolean DEFAULT true,
    role text,
    phone_num bigint,
    old_password text,
    forgot_password_code character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    login_otp bigint
);


ALTER TABLE public.userdetails OWNER TO postgreuser;

--
-- Name: account_emailaddress id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.account_emailaddress ALTER COLUMN id SET DEFAULT nextval('public.account_emailaddress_id_seq'::regclass);


--
-- Name: account_emailconfirmation id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.account_emailconfirmation ALTER COLUMN id SET DEFAULT nextval('public.account_emailconfirmation_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: django_site id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_site ALTER COLUMN id SET DEFAULT nextval('public.django_site_id_seq'::regclass);


--
-- Name: projectlisting id; Type: DEFAULT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.projectlisting ALTER COLUMN id SET DEFAULT nextval('public.projectlisting_id_seq'::regclass);


--
-- Data for Name: account_emailaddress; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.account_emailaddress (id, email, verified, "primary", user_id) FROM stdin;
\.


--
-- Data for Name: account_emailconfirmation; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.account_emailconfirmation (id, created, sent, key, email_address_id) FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add project details	7	add_projectdetails
26	Can change project details	7	change_projectdetails
27	Can delete project details	7	delete_projectdetails
28	Can view project details	7	view_projectdetails
29	Can add user details	8	add_userdetails
30	Can change user details	8	change_userdetails
31	Can delete user details	8	delete_userdetails
32	Can view user details	8	view_userdetails
33	Can add site	9	add_site
34	Can change site	9	change_site
35	Can delete site	9	delete_site
36	Can view site	9	view_site
37	Can add social application	10	add_socialapp
38	Can change social application	10	change_socialapp
39	Can delete social application	10	delete_socialapp
40	Can view social application	10	view_socialapp
41	Can add social account	11	add_socialaccount
42	Can change social account	11	change_socialaccount
43	Can delete social account	11	delete_socialaccount
44	Can view social account	11	view_socialaccount
45	Can add social application token	12	add_socialtoken
46	Can change social application token	12	change_socialtoken
47	Can delete social application token	12	delete_socialtoken
48	Can view social application token	12	view_socialtoken
49	Can add email address	13	add_emailaddress
50	Can change email address	13	change_emailaddress
51	Can delete email address	13	delete_emailaddress
52	Can view email address	13	view_emailaddress
53	Can add email confirmation	14	add_emailconfirmation
54	Can change email confirmation	14	change_emailconfirmation
55	Can delete email confirmation	14	delete_emailconfirmation
56	Can view email confirmation	14	view_emailconfirmation
57	Can add Token	15	add_token
58	Can change Token	15	change_token
59	Can delete Token	15	delete_token
60	Can view Token	15	view_token
61	Can add token	16	add_tokenproxy
62	Can change token	16	change_tokenproxy
63	Can delete token	16	delete_tokenproxy
64	Can view token	16	view_tokenproxy
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
2	pbkdf2_sha256$180000$eAz1Q8yX2AgZ$NqoogYM7ysWrby5R7Nt+6W0XxF2p8jcOZ3SHkEu7SuA=	2022-05-17 12:24:23.594897+05:30	f	demosuser				f	t	2022-05-17 12:24:23.033529+05:30
1	pbkdf2_sha256$320000$3SgSUOb0LaFylb9r0YpV37$VEnLALTSP3fAAoTjUT/qqyUzc425pE8jpd5KSKZy1l4=	2022-05-11 11:54:02.655738+05:30	t	bhuvanesh			bhuvanesh@gmail.com	t	t	2022-05-09 18:31:32.241892+05:30
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.authtoken_token (key, created, user_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	dsl	projectdetails
8	dsl	userdetails
9	sites	site
10	allauth	socialapp
11	allauth	socialaccount
12	allauth	socialtoken
13	account	emailaddress
14	account	emailconfirmation
15	authtoken	token
16	authtoken	tokenproxy
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2022-04-18 15:30:16.735858+05:30
2	auth	0001_initial	2022-04-18 15:30:17.304433+05:30
3	admin	0001_initial	2022-04-18 15:30:17.451123+05:30
4	admin	0002_logentry_remove_auto_add	2022-04-18 15:30:17.485003+05:30
5	admin	0003_logentry_add_action_flag_choices	2022-04-18 15:30:17.503552+05:30
6	contenttypes	0002_remove_content_type_name	2022-04-18 15:30:17.530315+05:30
7	auth	0002_alter_permission_name_max_length	2022-04-18 15:30:17.544386+05:30
8	auth	0003_alter_user_email_max_length	2022-04-18 15:30:17.559301+05:30
9	auth	0004_alter_user_username_opts	2022-04-18 15:30:17.576738+05:30
10	auth	0005_alter_user_last_login_null	2022-04-18 15:30:17.5897+05:30
11	auth	0006_require_contenttypes_0002	2022-04-18 15:30:17.594332+05:30
12	auth	0007_alter_validators_add_error_messages	2022-04-18 15:30:17.612264+05:30
13	auth	0008_alter_user_username_max_length	2022-04-18 15:30:17.696514+05:30
14	auth	0009_alter_user_last_name_max_length	2022-04-18 15:30:17.724196+05:30
15	auth	0010_alter_group_name_max_length	2022-04-18 15:30:17.746569+05:30
16	auth	0011_update_proxy_permissions	2022-04-18 15:30:17.803605+05:30
17	auth	0012_alter_user_first_name_max_length	2022-04-18 15:30:17.826444+05:30
18	sessions	0001_initial	2022-04-18 15:30:17.943791+05:30
19	account	0001_initial	2022-05-10 09:56:57.418288+05:30
20	account	0002_email_max_length	2022-05-10 09:56:57.627663+05:30
21	sites	0001_initial	2022-05-10 09:56:57.708775+05:30
22	sites	0002_alter_domain_unique	2022-05-10 09:56:57.765764+05:30
23	authtoken	0001_initial	2022-05-11 11:52:46.14716+05:30
24	authtoken	0002_auto_20160226_1747	2022-05-11 11:52:46.542331+05:30
25	authtoken	0003_tokenproxy	2022-05-11 11:52:46.575621+05:30
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
d82mjrhpx2sge6fbp7nvc1mi8b26m9g7	YWFiNTg0OWVlNDIxOTkwM2JkYzVjN2UxNGYzZDA3NzdiNzQ1MTExNTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJiYjQzNTk3MWFhMzE2YzdmYTI1ZThmY2E5NWFhYmIwMzUxYzE3Y2NiIn0=	2022-05-23 18:31:49.836464+05:30
7oohkzs6lqsw9rrmd6xh05wzl5stpfz2	YWFiNTg0OWVlNDIxOTkwM2JkYzVjN2UxNGYzZDA3NzdiNzQ1MTExNTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJiYjQzNTk3MWFhMzE2YzdmYTI1ZThmY2E5NWFhYmIwMzUxYzE3Y2NiIn0=	2022-05-25 11:54:02.677586+05:30
mjlj1pkpb1slki1f5tm28d08utrd388z	YjFiODkyYjRhODc0NWYxOGQwYWNhNWVlMTczZmEyZmRhMGUxMTc3MDp7ImFjY291bnRfdmVyaWZpZWRfZW1haWwiOm51bGwsIl9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5YmRjNGJjZmRjYzZiMmMwNDFlNWU3MWQ3NDZiOWYwMzcyMDkzYTAzIn0=	2022-05-31 12:24:23.656546+05:30
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.django_site (id, domain, name) FROM stdin;
1	example.com	example.com
\.


--
-- Data for Name: projectlisting; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.projectlisting (dns, project_name, project_description, tech_stack, versions, ip_address, git_url, status, button, id) FROM stdin;
http://someurl.com	sahyadri Ecommerce	This is the Magento backend for plp,pdp and other managements	Magento2/nginx/mysql	2.4.3/2.3/5.6	127.0.0.1	https://gitlab.com/	WIP	stop	2
http://someurl.com	Mast Bazzar	This is the Ecom Website for the users to purchase vegetables online	Magento2/NodeJS/Angular/nginx/mysql	2.3.3/12.23/8.9/2.1/8.0	127.0.0.1	https://gitlab.com/	Completed	start	3
http://someurl.com	Metro cash n carry	This is the Ecom Website for the users to purchase vegetables online	Magento2/nginx/mysql/angular/	2.4.3/2.3/5.6/9.8	127.0.0.1	https://gitlab.com/	Completed	start	4
http://someurl.com	Rare Rabbit	This is the Ecom Website for the users to purchase vegetables online	Magento1/nginx/mysql	2.4.3/2.3/5.6	127.0.0.1	https://gitlab.com/	Completed	start	5
http://someurl.com	Testing	This is the Ecom Website for the users to purchase vegetables online	Angular/NodeJS/python_oms/postgressql	8.9/12.23/3.8/12	127.0.0.1	https://gitlab.com/	Completed	start	1
http://someurl.com	Apollo POS	This is a point of service application for the In store employees to create and upload bills.	NodeJS(express)	12.24	127.0.0.1	https://gitlab.com/	Completed	stop	6
\.


--
-- Data for Name: projectlisting1; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.projectlisting1 (dns, project_name, project_description, tech_stack, versions, ip_address, git_url, status, button) FROM stdin;
http://someurl.com	Apollo POS	This is a point of service application for the In store employees to create and upload bills.	NodeJS(express)	12.24	127.0.0.1	https://gitlab.com/	Completed	Start / Stop Button
http://someurl.com	sahyadri Ecommerce	This is the Magento backend for plp,pdp and other managements	Magento2/nginx/mysql	2.4.3/2.3/5.6	127.0.0.1	https://gitlab.com/	WIP	Start / Stop Button
http://someurl.com	bhuvanesh	This is the Ecom Website for the users to purchase vegetables online	Angular/NodeJS/python_oms/postgressql	8.9/12.23/3.8/12	127.0.0.1	https://gitlab.com/	Completed	Start / Stop Button
http://someurl.com	Mast Bazzar	This is the Ecom Website for the users to purchase vegetables online	Magento2/NodeJS/Angular/nginx/mysql	2.3.3/12.23/8.9/2.1/8.0	127.0.0.1	https://gitlab.com/	Completed	Start / Stop Button
http://someurl.com	Metro cash n carry	This is the Ecom Website for the users to purchase vegetables online	Magento2/nginx/mysql/angular/	2.4.3/2.3/5.6/9.8	127.0.0.1	https://gitlab.com/	Completed	Start / Stop Button
http://someurl.com	Rare Rabbit	This is the Ecom Website for the users to purchase vegetables online	Magento1/nginx/mysql	2.4.3/2.3/5.6	127.0.0.1	https://gitlab.com/	Completed	Start / Stop Button
\.


--
-- Data for Name: userdetails; Type: TABLE DATA; Schema: public; Owner: postgreuser
--

COPY public.userdetails (username, email, password, is_active, role, phone_num, old_password, forgot_password_code, created_at, updated_at, login_otp) FROM stdin;
Adhi	adhithya@theretailinsights.com	adhi@123	t		\N	\N	\N	\N	\N	267739
bhuvi	bhuvanesh@theretailinsights.com	bhuvanesh@123	t	\N	9445678770	bhvanesh@123	MVAIUQ	2022-06-03 15:24:34.429895+05:30	2022-06-06 15:29:23.502639+05:30	625522
demos	demos@gmail.com	demos@123	t		\N	\N	BLWV2D	2022-06-03 15:24:57.143402+05:30	2022-06-06 11:17:46.454491+05:30	\N
\.


--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.account_emailaddress_id_seq', 1, false);


--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.account_emailconfirmation_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 64, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 2, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 16, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 25, true);


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.django_site_id_seq', 1, true);


--
-- Name: projectlisting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgreuser
--

SELECT pg_catalog.setval('public.projectlisting_id_seq', 11, true);


--
-- Name: account_emailaddress account_emailaddress_email_key; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_email_key UNIQUE (email);


--
-- Name: account_emailaddress account_emailaddress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_pkey PRIMARY KEY (id);


--
-- Name: account_emailconfirmation account_emailconfirmation_key_key; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_key_key UNIQUE (key);


--
-- Name: account_emailconfirmation account_emailconfirmation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: authtoken_token authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: projectlisting projectlisting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.projectlisting
    ADD CONSTRAINT projectlisting_pkey PRIMARY KEY (id);


--
-- Name: userdetails register_users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.userdetails
    ADD CONSTRAINT register_users_email_key UNIQUE (email);


--
-- Name: userdetails userdetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.userdetails
    ADD CONSTRAINT userdetails_pkey PRIMARY KEY (email);


--
-- Name: account_emailaddress_email_03be32b2_like; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX account_emailaddress_email_03be32b2_like ON public.account_emailaddress USING btree (email varchar_pattern_ops);


--
-- Name: account_emailaddress_user_id_2c513194; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX account_emailaddress_user_id_2c513194 ON public.account_emailaddress USING btree (user_id);


--
-- Name: account_emailconfirmation_email_address_id_5b7f8c58; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX account_emailconfirmation_email_address_id_5b7f8c58 ON public.account_emailconfirmation USING btree (email_address_id);


--
-- Name: account_emailconfirmation_key_f43612bd_like; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX account_emailconfirmation_key_f43612bd_like ON public.account_emailconfirmation USING btree (key varchar_pattern_ops);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: authtoken_token_key_10f0b77e_like; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: postgreuser
--

CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


--
-- Name: account_emailaddress account_emailaddress_user_id_2c513194_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_user_id_2c513194_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_emailconfirmation account_emailconfirm_email_address_id_5b7f8c58_fk_account_e; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirm_email_address_id_5b7f8c58_fk_account_e FOREIGN KEY (email_address_id) REFERENCES public.account_emailaddress(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken_token_user_id_35299eff_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_35299eff_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgreuser
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

