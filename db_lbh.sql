PGDMP      &    	            |            db_lbh    16.6    16.6     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16398    db_lbh    DATABASE     �   CREATE DATABASE db_lbh WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Indonesian_Indonesia.1252';
    DROP DATABASE db_lbh;
                postgres    false            M           1247    16400    jenis_kelamin_enum    TYPE     T   CREATE TYPE public.jenis_kelamin_enum AS ENUM (
    'Laki-laki',
    'Perempuan'
);
 %   DROP TYPE public.jenis_kelamin_enum;
       public          postgres    false            P           1247    16406    tipe_identitas_enum    TYPE     T   CREATE TYPE public.tipe_identitas_enum AS ENUM (
    'KTP',
    'KTM',
    'SIM'
);
 &   DROP TYPE public.tipe_identitas_enum;
       public          postgres    false            �            1259    24577    advokat    TABLE     �   CREATE TABLE public.advokat (
    advokat_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(50) NOT NULL
);
    DROP TABLE public.advokat;
       public         heap    postgres    false            �            1259    24576    advokat_advokat_id_seq    SEQUENCE     �   CREATE SEQUENCE public.advokat_advokat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.advokat_advokat_id_seq;
       public          postgres    false    218            �           0    0    advokat_advokat_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.advokat_advokat_id_seq OWNED BY public.advokat.advokat_id;
          public          postgres    false    217            �            1259    24586    advokat_kasus    TABLE     c  CREATE TABLE public.advokat_kasus (
    id integer NOT NULL,
    advokat_id integer,
    kasus_id integer,
    status character varying(20) DEFAULT 'Open'::character varying,
    CONSTRAINT advokat_kasus_status_check CHECK (((status)::text = ANY ((ARRAY['Open'::character varying, 'Assigned'::character varying, 'Close'::character varying])::text[])))
);
 !   DROP TABLE public.advokat_kasus;
       public         heap    postgres    false            �            1259    24585    advokat_kasus_id_seq    SEQUENCE     �   CREATE SEQUENCE public.advokat_kasus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.advokat_kasus_id_seq;
       public          postgres    false    220            �           0    0    advokat_kasus_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.advokat_kasus_id_seq OWNED BY public.advokat_kasus.id;
          public          postgres    false    219            �            1259    16414    kasus    TABLE     �  CREATE TABLE public.kasus (
    kasus_id integer NOT NULL,
    nama character varying(100) NOT NULL,
    jenis_kelamin public.jenis_kelamin_enum NOT NULL,
    tipe_identitas public.tipe_identitas_enum NOT NULL,
    unggah_identitas character varying(255) NOT NULL,
    alamat text NOT NULL,
    nomor_telepon character varying(15) NOT NULL,
    email character varying(100) NOT NULL,
    perihal text NOT NULL,
    tanggal_pengaduan date DEFAULT CURRENT_DATE
);
    DROP TABLE public.kasus;
       public         heap    postgres    false    845    848            �            1259    16413    kasus_kasus_id_seq    SEQUENCE     �   CREATE SEQUENCE public.kasus_kasus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.kasus_kasus_id_seq;
       public          postgres    false    216            �           0    0    kasus_kasus_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.kasus_kasus_id_seq OWNED BY public.kasus.kasus_id;
          public          postgres    false    215            ,           2604    24580    advokat advokat_id    DEFAULT     x   ALTER TABLE ONLY public.advokat ALTER COLUMN advokat_id SET DEFAULT nextval('public.advokat_advokat_id_seq'::regclass);
 A   ALTER TABLE public.advokat ALTER COLUMN advokat_id DROP DEFAULT;
       public          postgres    false    217    218    218            -           2604    24589    advokat_kasus id    DEFAULT     t   ALTER TABLE ONLY public.advokat_kasus ALTER COLUMN id SET DEFAULT nextval('public.advokat_kasus_id_seq'::regclass);
 ?   ALTER TABLE public.advokat_kasus ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    220    220            *           2604    16417    kasus kasus_id    DEFAULT     p   ALTER TABLE ONLY public.kasus ALTER COLUMN kasus_id SET DEFAULT nextval('public.kasus_kasus_id_seq'::regclass);
 =   ALTER TABLE public.kasus ALTER COLUMN kasus_id DROP DEFAULT;
       public          postgres    false    216    215    216            �          0    24577    advokat 
   TABLE DATA           A   COPY public.advokat (advokat_id, username, password) FROM stdin;
    public          postgres    false    218   J#       �          0    24586    advokat_kasus 
   TABLE DATA           I   COPY public.advokat_kasus (id, advokat_id, kasus_id, status) FROM stdin;
    public          postgres    false    220   �#       �          0    16414    kasus 
   TABLE DATA           �   COPY public.kasus (kasus_id, nama, jenis_kelamin, tipe_identitas, unggah_identitas, alamat, nomor_telepon, email, perihal, tanggal_pengaduan) FROM stdin;
    public          postgres    false    216   �#       �           0    0    advokat_advokat_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.advokat_advokat_id_seq', 5, true);
          public          postgres    false    217            �           0    0    advokat_kasus_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.advokat_kasus_id_seq', 15, true);
          public          postgres    false    219            �           0    0    kasus_kasus_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.kasus_kasus_id_seq', 5, true);
          public          postgres    false    215            7           2606    24593     advokat_kasus advokat_kasus_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.advokat_kasus
    ADD CONSTRAINT advokat_kasus_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.advokat_kasus DROP CONSTRAINT advokat_kasus_pkey;
       public            postgres    false    220            3           2606    24582    advokat advokat_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.advokat
    ADD CONSTRAINT advokat_pkey PRIMARY KEY (advokat_id);
 >   ALTER TABLE ONLY public.advokat DROP CONSTRAINT advokat_pkey;
       public            postgres    false    218            5           2606    24584    advokat advokat_username_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.advokat
    ADD CONSTRAINT advokat_username_key UNIQUE (username);
 F   ALTER TABLE ONLY public.advokat DROP CONSTRAINT advokat_username_key;
       public            postgres    false    218            1           2606    16421    kasus kasus_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.kasus
    ADD CONSTRAINT kasus_pkey PRIMARY KEY (kasus_id);
 :   ALTER TABLE ONLY public.kasus DROP CONSTRAINT kasus_pkey;
       public            postgres    false    216            8           2606    24594 +   advokat_kasus advokat_kasus_advokat_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.advokat_kasus
    ADD CONSTRAINT advokat_kasus_advokat_id_fkey FOREIGN KEY (advokat_id) REFERENCES public.advokat(advokat_id);
 U   ALTER TABLE ONLY public.advokat_kasus DROP CONSTRAINT advokat_kasus_advokat_id_fkey;
       public          postgres    false    220    218    4659            9           2606    24599 )   advokat_kasus advokat_kasus_kasus_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.advokat_kasus
    ADD CONSTRAINT advokat_kasus_kasus_id_fkey FOREIGN KEY (kasus_id) REFERENCES public.kasus(kasus_id);
 S   ALTER TABLE ONLY public.advokat_kasus DROP CONSTRAINT advokat_kasus_kasus_id_fkey;
       public          postgres    false    4657    216    220            �   C   x�3��N�,�L�400�2s2@#.cN���rۘ˄303)'��1�2��L�(*��L�b���� t8      �      x�34�4�4��/H������ 5)      �   �  x���Q��8���_q��kL��m5m՝��F����H���l�6�ο�5���UW]$����9�&c7-��F_�`�o�l��mx�V��k7�MQ܋ݽr��Y��O�c��h�����F��|S�Ֆ�f��֍�����	�kWC���f���5hXR���U�]Iv8�zF��n^�\���Y��v�;�Z��G�`������U�)�&cO@�ׄ�C�5���M�pr���Jʷk�*�@�6:���Dϙ����͜�1zݘ����^�'�R��2��e^ղr�s��w�b�K����j�ޡQp=��T�M)[�e۶)�J�R�D�ͮ�̏S��>�yp���^Qw��&
����@��|�RVb���:�TH&�Y.�ȲLJɎظ�NX^��"��K8@&�
j�����F��4��Ʒ<����iG-�!M����2��qR~����^)��I�5�w����I"*T=G *j98R���~7[��{@oj�gh�RmT^xq���'�*�~�Dwb���&@*���zJ��hB@��CJ�ң��@OZ�^��E�OI��Π{Z���I9���,eIJf���guOHσ����v12���g��@8��:���Gj�=Ɍkhh�29*�aIf���j����&�bU�7�>�=�6N3��~ҟ�&�\�]���-Ad�,�rd��v������ӵh_����D�����iD�e     