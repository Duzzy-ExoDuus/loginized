declare var __static: string;

export default class Constants {
    public static readonly BASE_PATH = process.env.NODE_ENV === 'development'
        ? __static.replace('/public', '') : __static.replace('/resources/app', '').replace('.asar', '');
    public static readonly VERSION = '1.2.1';
    public static readonly LATEST_RELEASE_URL = 'https://api.github.com/repos/juhaku/loginized/releases/latest';
    public static readonly IS_DEBUG = process.env.NODE_ENV === 'development';
}
